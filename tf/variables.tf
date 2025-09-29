variable "aws_region" {
  description = "Region to deploy AWS resources"
  type        = string
  default     = "us-east-1"
}

variable "hvn_region" {
  description = "Region to deploy HashiCorp Virtual Network"
  type        = string
  default     = "ap-southeast-1"
}

variable "hvn_id" {
  description = "HVN ID - used as a prefix for HCP resources"
  type        = string
}

variable "vault_cluster_tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers - dev, standard_small, standard_medium, standard_large, plus_small, plus_medium, plus_large"
  type        = string
  default     = "standard_small"
}

variable "vault_port" {
  description = "Vault Port"
  type        = number
  default     = 8200
}

locals {
  valid_instance_types = ["t2.micro", "t3.medium"]
}

variable "instance_type" {
  description = "The instance type for the EC2 instance that runs the sample client"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(local.valid_instance_types, var.instance_type)
    error_message = "Valid values for var: instance_type are (${jsonencode(local.valid_instance_types)})."
  }
}
