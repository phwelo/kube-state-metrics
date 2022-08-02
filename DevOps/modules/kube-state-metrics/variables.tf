variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type = string
  default = "~/.kube/config"
}

variable "requests" {
  description = "Resource requests"
  type = map(string)
  default = {
    "cpu" = "30m"
    "memory" = "30Mi"
  }
}

variable "limits" {
  description = "Resource limits"
  type = map(string)
  default = {
    cpu    = "60m"
    memory = "50Mi"
  }
}

variable "docker_image" {
  description = "Docker image to use for single container deployment"
  type = string
  default = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"
}

variable "health_check" {
  description = "Health check configuration"
  type = map(string)
  default = {
    "path"                  = "/healthz"
    "port"                  = "18080"
    "initial_delay_seconds" = 5
    "timeout_seconds"       = 5
  }
}

variable "docker_cmd" {
  description = "Docker command to use for single container deployment"
  type = list(string)
  default = [
    "/kube-state-metrics",
    "--port=18080",
    "--telemetry-port=18081"
  ]
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace to create"
  type = string
  default = "monitoring"
}

variable "app_name" {
  description = "Name of the app"
  type = string
  default = "kube-state-metrics"
}

variable "deployment_timeout" {
  description = "Timeout for the deployment to be ready"
  type = number
  default = 180
}

variable "cluster_role_rules" {
  description = "List of cluster role RBAC rules"
  type = list(map(list(string)))
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
    },
    {
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
