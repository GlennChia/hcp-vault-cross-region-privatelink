resource "aws_instance" "ec2_client" {
  ami                  = data.aws_ssm_parameter.al_2023_x86.value
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_client.name
  subnet_id            = aws_subnet.ec2_client_public1.id

  vpc_security_group_ids = [aws_security_group.ec2_client.id]

  user_data = templatefile(
    "./user-data/ec2-client.sh",
    {
      vault_address = hcp_vault_cluster.this.vault_private_endpoint_url # Using the VPCE URL leads to errors "https://${aws_vpc_endpoint.vault_hvd.dns_entry[0].dns_name}:${var.vault_port}"
      vault_token   = hcp_vault_cluster_admin_token.this.token
    }
  )

  tags = {
    Name = "ec2-client"
  }
}

resource "aws_security_group" "ec2_client" {
  name        = "ec2-client-sg"
  description = "Security group for EC2 Client"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_client_443_all" {
  security_group_id = aws_security_group.ec2_client.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All 443"

  tags = {
    Name = "all-443"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_client_sg_vault_port_from_private_link_sg" {
  security_group_id            = aws_security_group.ec2_client.id
  from_port                    = var.vault_port
  to_port                      = var.vault_port
  ip_protocol                  = "tcp"
  description                  = "${var.vault_port} to private link sg"
  referenced_security_group_id = aws_security_group.private_link.id

  tags = {
    Name = "ec2-client-sg-${var.vault_port}-private-link-sg"
  }
}

resource "aws_iam_role" "ec2_client" {
  name_prefix = "ec2-client"

  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_instance_profile" "ec2_client" {
  name_prefix = "ec2-client"
  role        = aws_iam_role.ec2_client.name
}

resource "aws_iam_role_policy_attachment" "ec2_client_ssm" {
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
  role       = aws_iam_role.ec2_client.name
}
