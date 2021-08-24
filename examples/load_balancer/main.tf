locals {
  deployment_name = "tamr-dev"
  project         = "your-project"
  region          = "us-east1"
  zone            = "us-east1-b"
}

module "tamr_stack" {
  source = "git::git@github.com:Datatamer/terraform-gcp-tamr-wrapper.git?ref=v0.4.0"
  deployment_name = local.deployment_name
  # tamr VM
  tamr_zip_uri        = "gs://tamr-releases/v2020.015.0/unify.zip"
  tamr_instance_image = "your-project/ubuntu"
  # bigtable config
  tamr_bigtable_min_nodes = 1
  tamr_bigtable_max_nodes = 10
  # network
  subnet_self_link = data.google_compute_subnetwork.project_subnet.self_link
  region           = local.region
  zone             = local.zone
  # misc
  # NOTE: this module will deploy all resources into this project
  project_id = local.project
}
#
# GLB
#

# assume ssl cert is uploaded to a google secret
data "google_secret_manager_secret_version" "ssl_key" {
  provider = google-beta
  project  = local.project
  secret   = "ssl_key"
}

data "google_secret_manager_secret_version" "ssl_cert" {
  provider = google-beta
  project  = local.project
  secret   = "ssl_cert"
}

# ssl
resource "google_compute_ssl_certificate" "tamr" {
  project     = local.project
  name        = "${local.deployment_name}-cert"
  private_key = data.google_secret_manager_secret_version.ssl_key.secret_data
  certificate = data.google_secret_manager_secret_version.ssl_cert.secret_data

  lifecycle {
    create_before_destroy = true
  }
}

# NOTE: this section is commented out, as it can't be planned and run until the above snippets have be run.

# module "load_balancer" {
#   source = "git::git@github.com:Datatamer/terraform-gcp-tamr-load-balancer.git?ref=v1.1.0"

#   name                   = local.deployment_name
#   project_id             = local.project
#   ssl_certificates       = [google_compute_ssl_certificate.tamr.id]
#   tamr_vm_self_link      = module.tamr_stack.tamr_instance_self_link
#   region                 = local.region
#   allow_source_ip_ranges = ["1.1.1.1/32"] # NOTE: replace this with your IP
# }

# resource "google_dns_record_set" "tamr-example-com" {
#   name = "${local.name}-ssl.example.com."
#   type = "A"
#   ttl  = 30
#   project = local.project

#   managed_zone = "example-zone"
#   rrdatas      = [module.load_balancer.ip_address]
# }
