terraform {
  backend "s3" {
    bucket       = "solar-info-cs-biz-1"
    key          = "deploy/prod/csf-tfstate/csf-prod.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
