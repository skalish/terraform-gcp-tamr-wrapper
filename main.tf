locals {
  subnetwork = replace(var.subnet_self_link, "https://www.googleapis.com/compute/v1/", "")

  # some resources have a force destroy (gcs), but others are deletion protection
  # (bigtable), need to have the opposite bool value.
  deletion_protection = var.force_destroy == true ? false : true

  admin_users = concat(
    var.additional_admin_users,
    [
      "serviceAccount:${module.iam.service_account_email}",
    ]
  )
  read_users = concat(
    var.additional_read_users,
    [
      "serviceAccount:${module.iam.service_account_email}",
    ]
  )
}

module "iam" {
  source = "git::git@github.com:Datatamer/terraform-gcp-tamr-iam?ref=v0.1.0"

  project_id                = var.project_id
  tamr_service_account      = var.tamr_instance_service_account
  tamr_service_account_name = var.deployment_name
}

module "cloud_sql" {
  source = "git::git@github.com:Datatamer/terraform-gcp-tamr-cloud-sql.git?ref=remove-for-each"
  name   = var.deployment_name

  project_id = var.project_id
  labels     = var.labels
  region     = var.region

  cloud_sql_viewer_members = local.read_users
  cloud_sql_client_members = local.admin_users

  disk_size = var.sql_disk_size
  disk_type = var.sql_disk_type
  tier      = var.sql_tier
}


module "gcs_buckets" {
  source = "git::git@github.com:Datatamer/terraform-gcp-tamr-buckets.git?ref=v2.2.0"

  project_id    = var.project_id
  labels        = var.labels
  force_destroy = var.force_destroy

  bucket_write_members = local.admin_users
  bucket_read_members  = local.read_users

  bucket_name_prefix = var.deployment_name
  bucket_locations   = var.bucket_locations
}

module "bigtable" {
  source = "git::git@github.com:Datatamer/terraform-gcp-bigtable.git?ref=v2.1.0"

  name    = var.deployment_name
  project = var.project_id
  zone    = var.zone

  deletion_protection = local.deletion_protection

  cloud_bigtable_admin_members = local.admin_users
}

module "tamr_vm" {
  source = "git::git@github.com:Datatamer/terraform-gcp-tamr-vm.git?ref=v0.1.0"
  # tamr VM
  tamr_instance_name            = var.deployment_name
  tamr_instance_zone            = var.zone
  tamr_instance_image           = var.tamr_instance_image
  tamr_instance_service_account = module.iam.service_account_email
  tamr_instance_subnet          = local.subnetwork
  tamr_instance_project         = var.project_id
  tamr_zip_uri                  = var.tamr_zip_uri
  # bigtable config
  tamr_bigtable_instance_id = module.bigtable.bigtable_instance_id
  tamr_bigtable_cluster_id  = module.bigtable.bigtable_cluster_id
  tamr_bigtable_min_nodes   = var.tamr_bigtable_min_nodes
  tamr_bigtable_max_nodes   = var.tamr_bigtable_max_nodes
  # dataproc
  tamr_dataproc_bucket = module.gcs_buckets.dataproc_bucket_name
  tamr_dataproc_region = var.region
  # cloud sql
  tamr_cloud_sql_location = var.region
  tamr_cloud_sql_name     = module.cloud_sql.instance_name
  tamr_sql_password       = module.cloud_sql.tamr_password
  # filesystem
  tamr_filesystem_bucket = module.gcs_buckets.tamr_bucket_name
  # misc
  labels = var.labels
}
