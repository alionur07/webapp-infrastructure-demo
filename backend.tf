terraform {
  backend "s3" {
    bucket         = "aoa-demo-terraform-state-storage"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1"
    dynamodb_table = "aoa-demo-terraform-state-locking"
  }
}