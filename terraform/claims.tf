resource "kubernetes_persistent_volume_claim" "pvc-jenkins" {
  metadata {
    name = "pvc-jenkins"
    namespace = "tools"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.jenkinsvolume.metadata.0.name }"
  }
}
resource "kubernetes_persistent_volume_claim" "pvc-nexus" {
  metadata {
    name = "pvc-nexus"
    namespace = "tools"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.nexusvolume.metadata.0.name }"
  }
}