module "kube-state-metrics" {
  source = "../single_container_deployment"
  kubeconfig_path = var.kubeconfig_path
  namespace_name = var.namespace_name
  app_name = var.app_name
  docker_image = var.docker_image
  health_check = var.health_check
  host_networking = var.host_networking
  docker_cmd = var.docker_cmd
  limits = var.limits
  requests = var.requests
  replicas = var.replicas
  deployment_timeout = var.deployment_timeout
  deployment_strategy = var.deployment_strategy
  cluster_role_rules = var.cluster_role_rules
  dd_config = var.dd_config
}
