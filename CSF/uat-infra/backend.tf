terraform {
  backend "s3" {
    bucket       = "sp-cvs-terraform-backend"
    key          = "csf/uat-infra.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
