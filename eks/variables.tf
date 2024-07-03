#########################################
# Default Variables
#########################################
variable "profile" {
  type    = string
  default = "default"
}

variable "main-region" {
  type    = string
  default = "us-east-1"
}

##########################################
# EKS Cluster Variables
##########################################
variable "cluster_name" {
  type    = string
  default = "tf-cluster"
}

#############################################
# ALB Controller Variables
#############################################
variable "env_name" {
  type    = string
  default = "dev"
}