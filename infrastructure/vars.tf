variable "hcloud_token" {
  type        = string
  description = "The api token to use for connecting to Hetzner Cloud."
}


variable "instance_location" {
  type        = string
  description = "The location where the instance should be created in."
  default     = "fsn1"
}

variable "postgres_domain" {
  type        = string
  description = "The domain for the kubernetes load balancer to point the workers to."
}




