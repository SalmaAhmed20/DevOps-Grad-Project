resource "kubernetes_persistent_volume" "jenkinsvolume" {
  metadata {
    name = "pv-jenkins"
  }
  spec {
    storage_class_name = ""
    claim_ref {
      name = "pvc-jenkins"
      namespace = "tools"
    }
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = "/var/jenkins_home"
      }
    }
  }
}

resource "kubernetes_persistent_volume" "nexusvolume" {
  metadata {
    name = "pv-nexus"
  }
  spec {
    storage_class_name = ""
    claim_ref {
      name = "pvc-nexus"
      namespace = "tools"
    }
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/home/docker/nexus-data"
      }
    }
  }
}