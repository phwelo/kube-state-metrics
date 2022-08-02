<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.primary_cluster_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.primary_role_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_deployment.primary_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_manifest.local_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.primary](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.local_sa_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the app | `string` | n/a | yes |
| <a name="input_cluster_role_rules"></a> [cluster\_role\_rules](#input\_cluster\_role\_rules) | n/a | `list(map(list(string)))` | n/a | yes |
| <a name="input_dd_config"></a> [dd\_config](#input\_dd\_config) | n/a | `map` | <pre>{<br>  "kube_state_url": "http://%%host%%:18080/metrics",<br>  "label_joins": {<br>    "kube_deployment_labels": {<br>      "labels_to_get": [<br>        "label_app",<br>        "label_deploy_env",<br>        "label_type",<br>        "label_magic_net",<br>        "label_canary"<br>      ],<br>      "labels_to_match": [<br>        "deployment"<br>      ]<br>    }<br>  },<br>  "labels_mapper": {<br>    "label_app": "app",<br>    "label_deploy_env": "deploy_env"<br>  },<br>  "min_collection_interval": 30,<br>  "prometheus_timeout": 30,<br>  "telemetry": true<br>}</pre> | no |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | Deployment strategy | `string` | `"Recreate"` | no |
| <a name="input_deployment_timeout"></a> [deployment\_timeout](#input\_deployment\_timeout) | Timeout for the deployment to be ready | `number` | `600` | no |
| <a name="input_docker_cmd"></a> [docker\_cmd](#input\_docker\_cmd) | Docker command to use for single container deployment | `list(string)` | n/a | yes |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | Docker image to use for single container deployment | `string` | n/a | yes |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check configuration | `map(string)` | <pre>{<br>  "initial_delay_seconds": 30,<br>  "path": "/health",<br>  "port": "8080",<br>  "timeout_seconds": 60<br>}</pre> | no |
| <a name="input_host_networking"></a> [host\_networking](#input\_host\_networking) | Enable host networking | `bool` | `true` | no |
| <a name="input_limits"></a> [limits](#input\_limits) | Resource limits | `map(string)` | n/a | yes |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | Name of the Kubernetes namespace to create | `string` | n/a | yes |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_requests"></a> [requests](#input\_requests) | Resource requests | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->