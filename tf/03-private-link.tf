# Create private link from HCP
resource "hcp_private_link" "this" {
  hvn_id           = hcp_hvn.this.hvn_id
  private_link_id  = "private-link-to-aws"
  vault_cluster_id = hcp_vault_cluster.this.cluster_id

  consumer_accounts = [
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  consumer_regions = [
    var.aws_region
  ]

  consumer_ip_ranges = [
    aws_vpc.ec2_client.cidr_block
  ]
}

# Create VPCE connecting to private link
resource "aws_vpc_endpoint" "vault_hvd" {
  vpc_id              = aws_vpc.ec2_client.id
  service_name        = hcp_private_link.this.external_name
  vpc_endpoint_type   = "Interface"
  service_region      = var.hvn_region
  private_dns_enabled = false # Private DNS can't be enabled because the service <service_name> does not provide a private DNS name.

  subnet_ids = [
    aws_subnet.ec2_client_endpoint1.id,
    aws_subnet.ec2_client_endpoint2.id
  ]

  security_group_ids = [
    aws_security_group.private_link.id
  ]

  tags = {
    Name        = "vault-hvd-endpoint"
    Environment = "Production"
  }
}

resource "aws_security_group" "private_link" {
  name        = "private-link-sg"
  description = "Security group for HVD Private Link"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "private-link-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_link_sg_vault_port_from_ec2_client_sg" {
  security_group_id            = aws_security_group.private_link.id
  from_port                    = var.vault_port
  to_port                      = var.vault_port
  ip_protocol                  = "tcp"
  description                  = "${var.vault_port} from EC2 client sg"
  referenced_security_group_id = aws_security_group.ec2_client.id

  tags = {
    Name = "private-link-sg-${var.vault_port}-ec2-client-sg"
  }
}
