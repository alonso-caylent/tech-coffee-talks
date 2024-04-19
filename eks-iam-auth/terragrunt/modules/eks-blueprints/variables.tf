variable cluster_name {
  type        = string
  default     = ""
  description = "description"
}

variable cluster_endpoint {
  type        = string
  default     = ""
  description = "description"
}

variable cluster_version {
  type        = number
  default     = 1.27
  description = "description"
}

variable cluster_certificate_authority_data {
  type        = string
  description = "description"
}

variable oidc_provider_arn {
  type        = string
  default     = ""
  description = "description"
}

variable region {
  type        = string
  default     = ""
  description = "description"
}

variable account_id {
  type        = string
  default     = ""
  description = "description"
}

variable vpc_id {
  type        = string
  default     = ""
  description = "description"
}

variable "tags" {
  type = map(string)
}

variable enable_aws_load_balancer_controller {
  type        = bool
  default     = false
  description = "description"
}

variable enable_metrics_server  {
  type        = bool
  default     = true
  description = "description"
}