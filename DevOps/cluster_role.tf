resource "kubernetes_cluster_role" "primary_cluster_role" {
  provider = kubernetes.local

  metadata {
    name = var.app_name

    labels = local.global_labels
  }

  dynamic "rule" {
    for_each = var.cluster_role_rules

    content {
      api_groups        = try(rule.value.api_groups, null)
      non_resource_urls = try(rule.value.non_resource_urls, null)
      resource_names    = try(rule.value.resource_names, null)
      resources         = try(rule.value.resources, null)
      verbs             = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_binding" "primary_role_binding" {
  provider = kubernetes.local

  metadata {
    name = "${var.app_name}-binding"

    labels = local.global_labels
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.primary_cluster_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_manifest.local_sa.manifest.metadata.name
    namespace = kubernetes_namespace.primary.metadata[0].name
    api_group = ""
  }
}