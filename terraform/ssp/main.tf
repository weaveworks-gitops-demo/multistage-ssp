terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.owner}-${var.stage}"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.stage
  }
}

module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.owner}-${var.stage}-eks"
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = var.instance_type
      asg_max_size  = var.asg_max_size
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
     host                  = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "wego-core" {
  name       = "wego-core"
  repository = "https://weaveworks.github.io/weave-gitops-ssp-addon/helm"
  chart      = "wego-core"
  version    = "0.0.1"
  namespace  = "wego-system"
  create_namespace = true
}

resource "helm_release" "ssp-bootstrap" {
  depends_on = [
    helm_release.wego_core
  ]
  name       = "wego-app"
  repository = "https://weaveworks.github.io/weave-gitops-ssp-addon/helm"
  chart      = "wego-app"
  version    = "0.0.1"
  namespace  = "wego-system"
  create_namespace = true

  set {
    name = "applications[0].applicationName"
    value = "ssp"
  }

  set {
    name = "applications[0].gitRepository"
    value = var.git_repository
  }

  set {
    name = "applications[0].privateKey"
    value = base64encode(var.private_key)
  }

  set {
    name = "applications[0].knownHosts"
    value = base64encode(var.known_hosts)
  }

  set {
    name = "applications[0].path"
    value = var.path
  }

  set {
    name = "applications[0].branch"
    value = var.branch
  }
}