#######################
# Cluster
#######################

output "cluster_arn" {
    description = "The Amazon Resource Name (ARN) of the cluster"
    value = module.eks.cluster_arn
}

output "cluster_certificate_autority_data" {
    description = "Base64 encoded certificate data required to comunicate with the cluster"
    value = module.eks.cluster_certificate_authority_data
}

output "cluster_enpoint" {
    description = "Endpoint for your K8s APi Server"
    value = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "The ID of the EKS Cluster. Note: currently a value is returned only for local EKS clusters"
  value = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS Cluster"
  value = module.eks.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS Cluster for the OpenID Connect identity provider"
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
    description = "Platform version for the cluster"
    value = module.eks.cluster_platform_version
}

output "cluster_status" {
    description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
    value = module.eks.cluster_status
}

output "cluster_security_group_id" {
    description = "Cluster security group that was created by Amazon EKS"
    value = module.eks.cluster_security_group_id
}

###########################################
# IRSA
###########################################

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https;//`)"
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value = module.eks.oidc_provider_arn
}

output "cluster_tls_certificate_sha1_fingerprint" {
  description = "The SHA1 fingerprint of the public key of the cluster's certificate"
  value = module.eks.cluster_tls_certificate_sha1_fingerprint
}