module "single_container_app" {
  source = "./modules/single_container_deployment"
  providers = {
    kubernetes = kubernetes.local
  }
}
