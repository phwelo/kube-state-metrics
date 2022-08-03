resource "kubernetes_namespace" "primary" {
  metadata {
    name = var.namespace_name
  }
}
