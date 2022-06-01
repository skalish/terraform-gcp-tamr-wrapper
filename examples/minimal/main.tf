module "tamr_stack" {
  source          = "git::git@github.com:Datatamer/terraform-gcp-tamr-vm.git?ref=v0.5.0"
  deployment_name = "tamr-dev"
  # tamr VM
  tamr_zip_uri        = "gs://tamr-releases/v2020.015.0/unify.zip"
  tamr_instance_image = "your-project/ubuntu"
  # bigtable config
  tamr_bigtable_min_nodes = 1
  tamr_bigtable_max_nodes = 10
  # network
  subnet_self_link = data.google_compute_subnetwork.project_subnet.self_link
  region           = "us-east1"
  zone             = "us-east1-b"
  # misc
  # NOTE: this module will deploy all resources into this project
  project_id = "your-project"
}
