variable "sg_name" {}
variable "description" {}
variable "vpc_id" {}
variable "tag" {}

variable "ingress_rules" {
  type = map(object({
    description = string
    cidr_ipv4   = string
    from_port   = number
    to_port     = number
    ip_protocol = string
  }))
  default = {}
}

variable "egress_rules" {
  type = map(object({
    description = string
    cidr_ipv4   = optional(string)
    ip_protocol = optional(string)
  }))
  default = {}
}