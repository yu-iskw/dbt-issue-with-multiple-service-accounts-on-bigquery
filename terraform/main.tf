#
# Service Accounts
#
resource "google_service_account" "dataset1_accessor" {
  project      = var.project_id
  account_id   = "test-dataset1-accessor"
  display_name = "test-dataset1-accessor"
}

resource "google_service_account" "dataset2_accessor" {
  project      = var.project_id
  account_id   = "test-dataset2-accessor"
  display_name = "test-dataset2-accessor"
}

#
# IAM
#
resource "google_project_iam_member" "bigquery_job_users" {
  for_each = toset([
    google_service_account.dataset1_accessor.email,
    google_service_account.dataset2_accessor.email,
  ])
  project  = var.project_id
  role     = "roles/bigquery.jobUser"
  member   = "serviceAccount:${each.key}"
}

#
# Impersonate service account
#
resource "google_service_account_iam_member" "dataset1_accessor_impersonation" {
  service_account_id = google_service_account.dataset1_accessor.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${var.your_gcp_account}"
}

resource "google_service_account_iam_member" "dataset2_accessor_impersonation" {
  service_account_id = google_service_account.dataset2_accessor.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${var.your_gcp_account}"
}

#
# BigQuery datasets
#
resource "google_bigquery_dataset" "dataset1" {
  project    = var.project_id
  dataset_id = "test_dataset1"
  location   = var.bigquery_location

  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "dataset2" {
  project    = var.project_id
  dataset_id = "test_dataset2"
  location   = var.bigquery_location

  delete_contents_on_destroy = true
}

#
# BigQuery permissions
#
resource "google_bigquery_dataset_access" "dataset1_accessor" {
  project       = var.project_id
  dataset_id    = google_bigquery_dataset.dataset1.dataset_id
  role          = "OWNER"
  user_by_email = google_service_account.dataset1_accessor.email
}

resource "google_bigquery_dataset_access" "dataset2_accessor" {
  project       = var.project_id
  dataset_id    = google_bigquery_dataset.dataset2.dataset_id
  role          = "OWNER"
  user_by_email = google_service_account.dataset2_accessor.email
}
