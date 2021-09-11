terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }

    github = {
      source  = "integrations/github"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "github_repository_deploy_key" "ssp_repository_deploy_key" {
  title      = "Deployment Key for SSP Repository"
  repository = "${var.repository_owner}/${var.repository_name}"
  key        = file("./key.pem.pub")
  read_only  = "false"
}

module "dev_stage" {
  source = "./terraform/ssp"
  region  = var.region
  stage  = "development"
  owner  = var.owner
  vpc_cidr  = var.vpc_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  kubernetes_version  = var.kubernetes_version
  instance_type  = var.development_instance_type
  asg_max_size  = var.development_asg_max_size
  git_repository  = "ssh://git@github.com/${var.repository_owner}/${var.repository_name}"
  private_key  = file("./key.pem")
  known_hosts  = file("./known_hosts")
  path  = "./environments/prod"
  branch  = "main"
}

module "uat_stage" {
  source = "./terraform/ssp"
  region  = var.region
  stage  = "uat"
  owner  = var.owner
  vpc_cidr  = var.vpc_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  kubernetes_version  = var.kubernetes_version
  instance_type  = var.development_instance_type
  asg_max_size  = var.development_asg_max_size
  git_repository  = "ssh://git@github.com/${var.repository_owner}/${var.repository_name}"
  private_key  = file("./key.pem")
  known_hosts  = file("./known_hosts")
  path  = "./environments/prod"
  branch  = "main"
}

module "prod_stage" {
  source = "./terraform/ssp"
  region  = var.region
  stage  = "prod"
  owner  = var.owner
  vpc_cidr  = var.vpc_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  kubernetes_version  = var.kubernetes_version
  instance_type  = var.development_instance_type
  asg_max_size  = var.development_asg_max_size
  git_repository  = "ssh://git@github.com/${var.repository_owner}/${var.repository_name}"
  private_key  = file("./key.pem")
  known_hosts  = file("./known_hosts")
  path  = "./environments/prod"
  branch  = "main"
}