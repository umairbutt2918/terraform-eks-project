terraform {

  backend "s3" {
    bucket = "terraform-eks-state-demo-123456"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/network"
}

module "eks" {
  source = "../../modules/eks"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnets
}