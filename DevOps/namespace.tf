resource "kubernetes_namespace" "primary" {
  provider = kubernetes.local

  metadata {
    name = var.namespace_name
  }
}
