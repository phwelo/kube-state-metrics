locals {
  # Labels to apply to all created resources
  global_labels = {
      app = var.app_name
  }

  # Datadog Agent configuration
  annotations = {
  # Full DD integration doc:
  # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
  "ad.datadoghq.com/${var.app_name}.check_names"  = jsonencode(["kubernetes_state"])
  "ad.datadoghq.com/${var.app_name}.init_configs" = "[{}]"
  "ad.datadoghq.com/${var.app_name}.instances" = jsonencode(
    [
      var.dd_config
    ])
  }
}
