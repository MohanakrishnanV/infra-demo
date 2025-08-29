terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-west-2"
  profile = "default"
}

provider "aws" {
  alias   = "accepter"
  region  = "us-west-2"
  profile = "account-cslr-apps-prod"
}
