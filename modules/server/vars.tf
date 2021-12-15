variable "hcloud_token" {
  type        = string
  description = "The api token to use for connecting to Hetzner Cloud."
}

variable "ssh_keys" {
  type        = list(string)
  description = "The ssh keys to use when setting up the instance."
}

variable "num_servers" {
  type        = number
  description = "The number of servers to create."
  default     = 1
}


variable "vpc_id" {
  type        = number
  description = "ID of the VPC to connect to."
}

variable "instance_type" {
  type        = string
  description = "The instance type that should be launched to host the wireguard client."
  default     = "cx11"
}

variable "instance_image" {
  type        = string
  description = "The image that should be used to create the machine."
  default     = "ubuntu-20.04"
}

variable "instance_name" {
  type        = string
  description = "The name that should be assigned to the machine."
  default     = "server"
}

variable "instance_location" {
  type        = string
  description = "The location where the instance should be created in."
  default     = "fsn1"
}
