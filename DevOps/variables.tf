variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type = string
  default = "~/.kube/config"
}

variable "docker_image" {
  description = "Docker image to use for single container deployment"
  type = string
  default = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"
}

variable "health_check" {
  default = {
    "path" = "/healthz"
    "port" = "18080"
    "initial_delay_seconds" = 5
    "timeout_seconds" = 5
  }
}

variable "host_networking" {
  description = "Enable host networking"
  type = bool
  default = true
}

variable "docker_cmd" {
  default = [
    "/kube-state-metrics",
    "--port=18080",
    "--telemetry-port=18081",
  ]
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace to create"
  type = string
  default = "mon" # !take this default out when moved to module
}

variable "app_name" {
  description = "Name of the app"
  type = string
  default = "state-metrics"
}

variable "replicas" {
  description = "Number of replicas"
  type = number
  default = 1
}

variable "deployment_timeout" {
  description = "Timeout for the deployment to be ready"
  type = number
  default = 180 # should default to 600 seconds after module pulled out
}

variable "deployment_strategy" {
  description = "Deployment strategy"
  type = string
  default = "Recreate"
  validation {
    condition     = contains(["Recreate", "RollingUpdate"], var.deployment_strategy)
    error_message = "Valid values for var: deploment_strategy are (\"Recreate\", \"RollingUpdate\")."
  } 
}

variable "cluster_role_rules" {
  type = list
  default = [
  {
    verbs      = ["list", "watch"],
    api_groups = [""],
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
    },{
      verbs      = ["list", "watch"],
      api_groups = ["extensions"],
      resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["apps"],
      resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["batch"],
      resources  = ["cronjobs", "jobs"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["autoscaling"],
      resources  = ["horizontalpodautoscalers"]
    },
    {
      verbs      = ["create"],
      api_groups = ["authentication.k8s.io"],
      resources  = ["tokenreviews"]
    },
    {
      verbs      = ["create"],
      api_groups = ["authorization.k8s.io"],
      resources  = ["subjectaccessreviews"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["policy"],
      resources  = ["poddisruptionbudgets"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["certificates.k8s.io"],
      resources  = ["certificatesigningrequests"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["storage.k8s.io"],
      resources  = ["storageclasses", "volumeattachments"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["admissionregistration.k8s.io"],
      resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["networking.k8s.io"],
      resources  = ["networkpolicies", "ingresses"]
    },
    {
      verbs      = ["list", "watch"],
      api_groups = ["coordination.k8s.io"],
      resources  = ["leases"]
    }
]
}

locals {
  # Labels to apply to all created resources
  global_labels = {
      app = var.app_name
  }

  annotations = {
  # Full DD integration doc:
  # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
  "ad.datadoghq.com/${var.app_name}.check_names"  = jsonencode(["kubernetes_state"])
  "ad.datadoghq.com/${var.app_name}.init_configs" = "[{}]"
  "ad.datadoghq.com/${var.app_name}.instances" = jsonencode(
    [
      {
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
          label_app        = "app"
          label_deploy_env = "deploy_env"
        }
      }
    ])
  }
}

