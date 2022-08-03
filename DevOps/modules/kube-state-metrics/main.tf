module "kube-state-metrics" {
  source             = "../single-container-deployment"
  namespace_name     = var.namespace_name
  app_name           = var.app_name
  docker_image       = var.docker_image
  health_check       = var.health_check
  docker_cmd         = var.docker_cmd
  limits             = var.limits
  requests           = var.requests
  deployment_timeout = var.deployment_timeout
  cluster_role_rules = var.cluster_role_rules
}
