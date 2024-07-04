#######################################
#### EKS Cluster ######################
#######################################

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"

    cluster_name = "eks-cluster"
    cluster_version = "1.30"

    cluster_endpoint_public_access = true


    cluster_addons = {
        coredns = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
        aws-ebs-csi-driver = {
            most_recent = true
        }
    }

    vpc_id = var.vpc_id

    subnet_ids = var.private_subnets
    control_plane_subnet_ids = var.private_subnets

    # Eks Managed node Groups
    eks_managed_node_group_defaults = {
        ami_type       = "AL2_x86_64"
        instance_types = ["m5.large"]

        attach_cluster_primary_security_group = true
    }

    eks_managed_node_groups = {
    node1 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "helloworld"
      }
    }
}

manage_aws_auth_configmap = true

  tags = {
    env       = "dev"
    terraform = "true"
  }
}
