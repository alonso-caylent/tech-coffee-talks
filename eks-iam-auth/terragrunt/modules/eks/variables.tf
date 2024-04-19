variable name {
  type        = string
  default     = ""
  description = "description"
}

variable cluster_version {
  type        = number
  default     = 1.27
  description = "description"
}

variable region {
  type        = string
  default     = ""
  description = "description"
}
variable vpc_id {
  type        = string
  default     = ""
  description = "description"
}

variable private_subnets {
  type        = list(string)
  description = "description"
}

variable intra_subnets {
  type        = list(string)
  description = "description"
}

variable "tags" {
  type = map(string)
}