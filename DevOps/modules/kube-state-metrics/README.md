<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kube-state-metrics"></a> [kube-state-metrics](#module\_kube-state-metrics) | ../single_container_deployment | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the app | `string` | `"kube-state-metrics"` | no |
| <a name="input_cluster_role_rules"></a> [cluster\_role\_rules](#input\_cluster\_role\_rules) | n/a | `list(map(list(string)))` | <pre>see below</pre> | no |
| <a name="input_deployment_timeout"></a> [deployment\_timeout](#input\_deployment\_timeout) | Timeout for the deployment to be ready | `number` | `180` | no |
| <a name="input_docker_cmd"></a> [docker\_cmd](#input\_docker\_cmd) | Docker command to use for single container deployment | `list(string)` | <pre>[<br>  "/kube-state-metrics",<br>  "--port=18080",<br>  "--telemetry-port=18081"<br>]</pre> | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | Docker image to use for single container deployment | `string` | `"k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check configuration | `map(string)` | <pre>{<br>  "initial_delay_seconds": 5,<br>  "path": "/healthz",<br>  "port": "18080",<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file | `string` | `"~/.kube/config"` | no |
| <a name="input_limits"></a> [limits](#input\_limits) | Resource limits | `map(string)` | <pre>{<br>  "cpu": "60m",<br>  "memory": "50Mi"<br>}</pre> | no |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | Name of the Kubernetes namespace to create | `string` | `"monitoring"` | no |
| <a name="input_requests"></a> [requests](#input\_requests) | Resource requests | `map(string)` | <pre>{<br>  "cpu": "30m",<br>  "memory": "30Mi"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->