terraform {
  backend "s3" {
    bucket       = "terraform-backend-us-east-1-satya"
    key          = "backend-locking"
    region       = "us-east-1"
    use_lockfile = true
  }
}