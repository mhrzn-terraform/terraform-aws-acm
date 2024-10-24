variable "hostname" {
  description = "The DNS domain that will point at this"
  type        = string
}

variable "enable_wildcard_certificate" {
  description = "Enable if wildcard certificate is required"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of SNI domains"
  type        = list(string)
}