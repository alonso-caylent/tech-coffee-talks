variable name {
  type        = string
  default     = ""
  description = "description"
}

variable "tags" {
  type = map(string)
}

variable cluster_name {
  type        = string
  default     = ""
  description = "description"
}

variable namespace {
  type        = string
  default     = ""
  description = "description"
}

variable service_account {
  type        = string
  default     = ""
  description = "description"
}