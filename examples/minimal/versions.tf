terraform {
  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project-id
  region  = "us-east1"
  version = "~> 3.29.0"
}

provider "google-beta" {
  project = var.project-id
  region  = "us-east1"
  version = "~> 3.29.0"
}
