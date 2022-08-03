variable "docker_image" {
  description = "Docker image to use for single container deployment"
  type = string
}

variable "docker_cmd" {
  description = "Docker command to use for single container deployment"
  type = list(string)
}

variable "requests" {
  description = "Resource requests"
  type = map(string)
}

variable "limits" {
  description = "Resource limits"
  type = map(string)
}

variable "health_check" {
  description = "Health check configuration"
  type = map(string)
  default = {
    "path"                  = "/health"
    "port"                  = "8080"
    "initial_delay_seconds" = 30
    "timeout_seconds"       = 60
  }
}

variable "host_networking" {
  description = "Enable host networking"
  type = bool
  default = true
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace to create"
  type = string
}

variable "app_name" {
  description = "Name of the app"
  type = string
}

variable "replicas" {
  description = "Number of replicas"
  type = number
  default = 1
}

variable "deployment_timeout" {
  description = "Timeout for the deployment to be ready"
  type = number
  default = 600
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

variable "cluster_role_rules" { # https://kubernetes.io/docs/reference/access-authn-authz/rbac/
  type = list(map(list(string)))
}

variable "dd_config" {
  default = {
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
          "label_canary"
        ]
      }
    }
    labels_mapper = {
      label_app        = "app"
      label_deploy_env = "deploy_env"
    }
  }
}
