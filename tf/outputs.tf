output "hcp_vault_private_endpoint_url" {
  description = "The private URL for the Vault cluster"
  value       = hcp_vault_cluster.this.vault_private_endpoint_url
}

output "private_link_regional_dns_name" {
  description = "The private link regional DNS Name"
  value       = aws_vpc_endpoint.vault_hvd.dns_entry[0].dns_name
}
