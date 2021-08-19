#
# IAM
#
variable "additional_admin_users" {
  default     = []
  type        = list(string)
  description = "list of additional entities to give admin permissions to provisioned resources"
}

variable "additional_read_users" {
  default     = []
  type        = list(string)
  description = "list of additional entities to give read only permissions to provisioned resources"
}

variable "tamr_instance_service_account" {
  default     = ""
  type        = string
  description = "email of service account to attach to the tamr instance. If not given will create a new service account for tamr to use."
}

#
# Tamr VM
#
variable "tamr_instance_image" {
  type        = string
  description = "Image to use for Tamr VM boot disk"
}

variable "tamr_zip_uri" {
  type        = string
  description = "gcs location to download tamr zip from"
}
# TODO: vm settings


#
# GCP LB
#
# TODO:

#
# SQL
#
variable "sql_tier" {
  type        = string
  description = "the machine type to use for the sql instance"
  default     = "db-custom-2-4096"
}

variable "sql_disk_size" {
  type        = number
  description = "size of the disk to use on the tamr sql instance"
  default     = 10
}

variable "sql_disk_type" {
  type        = string
  description = "The disk type to use on the cloud SQL instance. should be either PD_SSD or PD_STANDARD"
  default     = "PD_SSD"
}

#
# Bigtable
#
variable "tamr_bigtable_min_nodes" {
  type        = string
  description = "Min number of nodes to scale down to"
}

variable "tamr_bigtable_max_nodes" {
  type        = string
  description = "Max number of nodes to scale up to"
}
#
# GCS
#
variable "bucket_locations" {
  type        = string
  description = "Location for the gcs buckets, default is `US`"
  default     = "US"
}

# Misc
#
variable "project_id" {
  type        = string
  description = "project_id for resources to be deployed into"
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources into"
}

variable "zone" {
  type        = string
  description = "GCP zone to deploy resources into"
}

variable "deployment_name" {
  type        = string
  description = "name to use as the base for all resources created. NOTE: if you change this it will recreate all resources"
}

variable "subnet_self_link" {
  type        = string
  description = "subnetwork self_link to deploy resources onto"
}

variable "labels" {
  default     = {}
  type        = map(string)
  description = "Labels to attach to created resources"
}

variable "force_destroy" {
  default     = false
  type        = bool
  description = "force destroy potentially persistent resources, like bigtable/gcs"
}
