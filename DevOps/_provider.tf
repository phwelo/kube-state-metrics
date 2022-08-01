provider "kubernetes" {
  alias = "local"
  config_path = pathexpand(var.kubeconfig_path)
}
