variable "server_port" {
  description = "An example of a number variable"
  type        = number
  default     = 5000
}
variable "ssh_port" {
  description = "An example of a number variable"
  type        = number
  default     = 22
}
variable "cluster_name"{
  description = "The name to use fr all the cluster resources"
  type=string
}
variable "instance_type"{
  description = "Instance type"
  type=string
}

variable "min_size"{
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
}
variable "max_size"{
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
}