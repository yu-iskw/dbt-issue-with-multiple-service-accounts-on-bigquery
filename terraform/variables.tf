variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "your_gcp_account" {
  description = "Your GCP account email"
  type        = string
}

variable "bigquery_location" {
  description = "BigQuery location"
  type        = string
  default     = "US"
}
