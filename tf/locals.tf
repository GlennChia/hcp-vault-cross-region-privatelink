locals {
  matching_azs = [
    for az in data.aws_availability_zones.available.names :
    az if contains(data.aws_ec2_instance_type_offerings.az.locations, az)
  ]

  vault_private_endpoint_host = regex("https?://([^:/]+)", hcp_vault_cluster.this.vault_private_endpoint_url)[0]
}