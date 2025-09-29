resource "hcp_vault_cluster" "this" {
  hvn_id          = hcp_hvn.this.hvn_id
  cluster_id      = "vault-cluster"
  tier            = var.vault_cluster_tier
  public_endpoint = false
}

resource "hcp_vault_cluster_admin_token" "this" {
  cluster_id = hcp_vault_cluster.this.cluster_id
}
