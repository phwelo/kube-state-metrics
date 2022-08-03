module "kube-state-metrics" {
  source         = "./modules/kube-state-metrics"
  namespace_name = "mon"
  app_name       = "state-metrics"
  providers = {
    kubernetes = kubernetes.local
  }
}
