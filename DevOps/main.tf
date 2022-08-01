module "kube-state-metrics" {
  source = "./modules/kube-state-metrics"
  providers = {
    kubernetes = kubernetes.local
  }
}
