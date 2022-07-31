/*
  NOTE: Using `kubernetes_manifest` resource due to a bug in the terraform provider. Details can be found here:
  https://github.com/hashicorp/terraform-provider-kubernetes/issues/1724#issuecomment-1139450178
*/
resource "kubernetes_manifest" "local_sa" {
  provider = kubernetes.local

  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      namespace = kubernetes_namespace.primary.metadata[0].name
      name      = var.app_name

      labels = local.global_labels
    }

    automountServiceAccountToken = false
  }
}

resource "kubernetes_secret" "local_sa_token" {
  provider = kubernetes.local

  metadata {
    name      = "${var.app_name}-token"
    namespace = kubernetes_namespace.primary.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_manifest.local_sa.manifest.metadata.name
    }
  }

  type = "kubernetes.io/service-account-token"
}
