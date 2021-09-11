variable "region" { type = string }
variable "owner" { type = string }
variable "vpc_cidr" { type = string }
variable "private_subnet_cidrs" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "kubernetes_version" { type = string }

variable "development_instance_type" { type = string }
variable "development_asg_max_size" { type = number }

variable "uat_instance_type" { type = string }
variable "uat_asg_max_size" { type = number }

variable "production_instance_type" { type = string }
variable "production_asg_max_size" { type = number }

variable "repository_owner" { type = string }
variable "repository_name" { type = string }
variable "private_key" { type = string }
variable "known_hosts" { type = string }
variable "path" { type = string }
variable "branch" { type = string }