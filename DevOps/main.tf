module "single_container_app" {
  source = "./modules/kube-state-metrics"
  providers = {
    kubernetes = kubernetes.local
  }
}
