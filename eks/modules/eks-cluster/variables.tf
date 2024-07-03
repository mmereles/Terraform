####################################
# General Variables from root module
####################################

variable "main-region" {
  type = string
}

####################################
# Variables from other modules
####################################

variable "vpc_id" {
    description = "VPC ID which EKS Cluster is deployed in"
    type = string
}

variable "private_subnets" {
  description = "VPC Private Subnets which EKS cluster is deployed in"
  type        = list(any)
}

######################################################
# Variables defined using Environments Variables
######################################################
