/*
  NOTE: Using `kubernetes_manifest` resource due to a bug in the terraform provider. Details can be found here:
  https://github.com/hashicorp/terraform-provider-kubernetes/issues/1724#issuecomment-1139450178
*/
resource "kubernetes_manifest" "state_metrics_local_sa" {
  provider = kubernetes.local

  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      namespace = kubernetes_namespace.mon_local.metadata[0].name
      name      = var.app_name

      labels = {
        app = var.app_name
      }
    }

    automountServiceAccountToken = false
  }
}

resource "kubernetes_secret" "state_metrics_local_sa_token" {
  provider = kubernetes.local

  metadata {
    name      = "${var.app_name}-token"
    namespace = kubernetes_namespace.mon_local.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_manifest.state_metrics_local_sa.manifest.metadata.name
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "state_metrics_local" {
  provider = kubernetes.local

  metadata {
    name = var.app_name

    labels = {
      app = var.app_name
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources = [
      "configmaps",
      "secrets",
      "nodes",
      "pods",
      "services",
      "resourcequotas",
      "replicationcontrollers",
      "limitranges",
      "persistentvolumeclaims",
      "persistentvolumes",
      "namespaces",
      "endpoints"
    ]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}

resource "kubernetes_cluster_role_binding" "state_metrics_local" {
  provider = kubernetes.local

  metadata {
    name = "${var.app_name}-binding"

    labels = {
      app = var.app_name
    }
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.state_metrics_local.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_manifest.state_metrics_local_sa.manifest.metadata.name
    namespace = kubernetes_namespace.mon_local.metadata[0].name
    api_group = ""
  }
}

resource "kubernetes_deployment" "state_metrics_local" {
  provider = kubernetes.local

  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.mon_local.metadata[0].name

    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    progress_deadline_seconds = 180

    template {
      metadata {
        namespace = kubernetes_namespace.mon_local.metadata[0].name
        labels = {
          app = var.app_name
        }

        annotations = {
          # Full DD integradion doc:
          # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
          "ad.datadoghq.com/${var.app_name}.check_names"  = jsonencode(["kubernetes_state"])
          "ad.datadoghq.com/${var.app_name}.init_configs" = "[{}]"
          "ad.datadoghq.com/${var.app_name}.instances" = jsonencode([{
            kube_state_url          = "http://%%host%%:18080/metrics"
            prometheus_timeout      = 30
            min_collection_interval = 30
            telemetry               = true
            label_joins = {
              kube_deployment_labels = {
                labels_to_match = ["deployment"]
                labels_to_get = [
                  "label_app",
                  "label_deploy_env",
                  "label_type",
                  "label_magic_net",
                  "label_canary",
                ]
              }
            }
            labels_mapper = {
              # We rename following labels because app and deploy_env are our "well known labels"
              label_app        = "app"
              label_deploy_env = "deploy_env"
            }
          }])
        }
      }

      spec {
        enable_service_links            = false
        service_account_name            = kubernetes_manifest.state_metrics_local_sa.manifest.metadata.name
        automount_service_account_token = true

        host_network = true

        container {
          # docker run --rm -it k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8 --help
          image                    = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"
          image_pull_policy        = "IfNotPresent"
          name                     = var.app_name
          termination_message_path = "/dev/termination-log"
          command = [
            "/kube-state-metrics",
            "--port=18080",
            "--telemetry-port=18081",
          ]

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "18080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          resources {
            requests = {
              cpu    = "30m"
              memory = "30Mi"
            }

            limits = {
              cpu    = "60m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.state_metrics_local,
  ]
}
