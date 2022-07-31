locals {
  # Labels to apply to all created resources
  global_labels = {
      app = var.app_name
  }

  annotations = {
  # Full DD integration doc:
  # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
  "ad.datadoghq.com/${var.app_name}.check_names"  = jsonencode(["kubernetes_state"])
  "ad.datadoghq.com/${var.app_name}.init_configs" = "[{}]"
  "ad.datadoghq.com/${var.app_name}.instances" = jsonencode(
    [
      {
        kube_state_url          = "http://%%host%%:18080/metrics"
        prometheus_timeout      = 30
        min_collection_interval = 30
        telemetry               = true
        label_joins = {
          kube_deployment_labels = {
            labels_to_match = ["deployment"]
            labels_to_get = [
              "label_app",
              "label_deploy_env",
              "label_type",
              "label_magic_net",
              "label_canary"
            ]
          }
        }
        labels_mapper = {
          label_app        = "app"
          label_deploy_env = "deploy_env"
        }
      }
    ])
  }
}
