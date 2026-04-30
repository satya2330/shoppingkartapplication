resource "aws_security_group" "node_group_remote_access" {
  name   = "allow_ssh_nodes"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.31"

  # Setting to true since you'll likely access this from your local machine/Jenkins
  cluster_endpoint_public_access = true

  # EKS Access Entries (Replaces the old aws-auth ConfigMap)
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # Replace the principal_arn with your actual IAM User/Role ARN
    admin_user = {
      principal_arn = "arn:aws:iam::876997124628:user/terraform"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id                   = module.vpc.vpc_id
  # Updated to use private_subnets to match your vpc.tf output
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    tws-demo-ng = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      disk_size      = 35

      tags = {
        Name = "tws-demo-ng"
      }
    }
  }

  tags = local.tags
}

data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [module.eks.cluster_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}