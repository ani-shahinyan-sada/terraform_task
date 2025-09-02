terraform {
  backend "gcs" {
    bucket = "ani_project_task"
    prefix = "tfpractice"
  }
}
