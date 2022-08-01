# migration script
terraform state mv kubernetes_cluster_role.primary_cluster_role module.single_container_app.kubernetes_cluster_role.primary_cluster_role 
terraform state mv kubernetes_cluster_role_binding.primary_role_binding module.single_container_app.kubernetes_cluster_role_binding.primary_role_binding
terraform state mv kubernetes_deployment.primary_deployment module.single_container_app.kubernetes_deployment.primary_deployment
terraform state mv kubernetes_manifest.local_sa module.single_container_app.kubernetes_manifest.local_sa
terraform state mv kubernetes_namespace.primary module.single_container_app.kubernetes_namespace.primary
terraform state mv kubernetes_secret.local_sa_token module.single_container_app.kubernetes_secret.local_sa_token
