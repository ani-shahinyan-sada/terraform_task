resource "google_monitoring_dashboard" "recipe_app_dashboard" {
  project        = var.service_project_id
  dashboard_json = jsonencode({
    displayName = "Recipe App Dashboard"
    mosaicLayout = {
      tiles = [
        {
          widget = {
            title = "Request Rate (per minute)"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_v2_service.default.name}\""
                    aggregation = {
                      alignmentPeriod    = "60s"
                      perSeriesAligner   = "ALIGN_RATE"
                    }
                  }
                }
                plotType = "LINE"
              }]
            }
          }
        },

        {
          widget = {
            title = "Response Time (ms)"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_v2_service.default.name}\" AND metric.type=\"run.googleapis.com/request_latencies\""
                    aggregation = {
                      alignmentPeriod    = "60s"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                  }
                }
                plotType = "LINE"
              }]
            }
          }
        },

        {
          widget = {
            title = "Error Rate (5xx responses)"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_v2_service.default.name}\" AND metric.labels.response_code_class=\"5xx\""
                    aggregation = {
                      alignmentPeriod    = "60s"
                      perSeriesAligner   = "ALIGN_RATE"
                    }
                  }
                }
                plotType = "LINE"
              }]
            }
          }
        },

        {
          widget = {
            title = "Database Connection Status"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "resource.type=\"cloudsql_database\" AND resource.labels.database_id=\"${var.service_project_id}:${module.mysql-db.instance_name}\""
                    aggregation = {
                      alignmentPeriod    = "60s"
                      perSeriesAligner   = "ALIGN_MEAN"
                    }
                  }
                }
                plotType = "LINE"
              }]
            }
          }
        }
      ]
    }
  })
}

resource "google_monitoring_alert_policy" "app_down" {
  project      = var.service_project_id
  display_name = "Recipe App Down"
  combiner = "OR"
  conditions {
    display_name = "No requests in 5 minutes"
    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_v2_service.default.name}\""
      duration        = "300s"
      comparison      = "COMPARISON_EQUAL"
      threshold_value = 0
 
    }
  }
}