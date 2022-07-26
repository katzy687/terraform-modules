###########################
# Need to tag netwroks  https://stackoverflow.com/questions/66039501/eks-alb-is-not-to-able-to-auto-discover-subnets 
# or if the subnets are also used by non-EKS resources kubernetes.io/cluster/${your-cluster-name}: shared
##########################

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}-${var.SANDBOX_ID}"
  cluster_version = "1.22"
  # subnets         = var.subnets
  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
  # Determines whether to create an OpenID Connect Provider for EKS to enable IRSA Default: true
  # enable_irsa = false

  cluster_addons = {
    # Note: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html#fargate-gs-coredns
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  eks_managed_node_groups = {
    bottlerocket_default = {
      create_launch_template = false
      launch_template_name   = ""

      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"
      instance_types       = [var.instance_type]
      min_size     = var.min_node_size
      max_size     = var.max_node_size
      desired_size = var.desired_node_size
      subnet_ids           = module.vpc.public_subnets
    }
  }
  
  # aws-auth configmap
  manage_aws_auth_configmap = true
  # aws_auth_roles = var.map_roles
  # aws_auth_users = var.map_users
}
