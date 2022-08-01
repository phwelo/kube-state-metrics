resource "kubernetes_deployment" "primary_deployment" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.primary.metadata[0].name

    labels = local.global_labels
  }

  spec {
    replicas = var.replicas

    strategy {
      type = var.deployment_strategy
    }

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    progress_deadline_seconds = var.deployment_timeout

    template {
      metadata {
        namespace = kubernetes_namespace.primary.metadata[0].name
        labels = local.global_labels
        annotations = local.annotations
      }

      spec {
        enable_service_links            = false
        service_account_name            = kubernetes_manifest.local_sa.manifest.metadata.name
        automount_service_account_token = true
        host_network                    = var.host_networking

        container {
          # docker run --rm -it k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8 --help
          image                    = var.docker_image
          image_pull_policy        = "IfNotPresent" # Other valid options: "Always" or "Never"
          name                     = var.app_name
          termination_message_path = "/dev/termination-log"
          command = var.docker_cmd

          readiness_probe {
            http_get {
              path = var.health_check["path"]
              port = var.health_check["port"]
            }

            initial_delay_seconds = var.health_check["initial_delay_seconds"]
            timeout_seconds       = var.health_check["timeout_seconds"]
          }

          resources {
            requests = var.requests
            limits = var.limits
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.primary_role_binding,
  ]
}
