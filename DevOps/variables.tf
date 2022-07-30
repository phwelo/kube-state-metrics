variable "kubeconfig_path" {
    description = "Path to the kubeconfig file"
    type = string
    default = "~/.kube/config"
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

