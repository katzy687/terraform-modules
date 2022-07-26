variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "cluster_name" {
  default = "eks-test"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "max_node_size" {
  type = number
  default = 5
}

variable "min_node_size" {
  type = number
  default = 1
}

variable "desired_node_size" {
  type = number
  default = 2
}

variable "SANDBOX_ID" {
  default = "test"
}


# variable "map_roles" {
#   description = "Additional IAM roles to add to the aws-auth configmap."
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = [
#     {
#       rolearn  = "arn:aws:iam::XXXXXX:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_PowerUsers"
#       username = "QualiPowerUsers"
#       groups   = ["system:masters"]
#     }
#   ]
# }

# variable "map_users" {
#   description = "Additional IAM users to add to the aws-auth configmap."
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = [
#     {
#       userarn  = "arn:aws:iam::XXXXXXX:user/someuser"
#       username = "alex.az"
#       groups   = ["system:masters"]
#     }
#   ]
# }