output "node_address" {
  value = kubernetes_service_v1.minio.spec[0].cluster_ip
}

output "access_key_id" {
  value = kubernetes_secret_v1.access_key_id.data.value
}

output "secret_access_key" {
  value = kubernetes_secret_v1.secret_access_key.data.value
}
