region = "us-east-1"
owner = "infra"
vpc_cidr = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["us-east-1a","us-east-1b"]
kubernetes_version = "1.21"
//repository_owner = "murillodigital"
//repository_name = "team-ssp"
branch = "main"

development_instance_type = "m4.large"
development_asg_max_size = 3

uat_instance_type = "m4.large"
uat_asg_max_size = 3

production_instance_type = "m4.large"
production_asg_max_size = 3