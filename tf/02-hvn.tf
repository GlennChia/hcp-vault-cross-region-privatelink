resource "hcp_hvn" "this" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = "10.4.0.0/16"
}
