resource "kubernetes_deployment" "nexus" {
  metadata {
    name      = "nexus"
    namespace = "tools"
    labels = {
      test = "nexus"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        test = "nexus"
      }
    }
    template {
      metadata {
        labels = {
          test = "nexus"
        }
      }
      spec {
        container {
          image = "sonatype/nexus3"
          name  = "nexus"

          port {
            container_port = 8081
          }
          port {
            container_port = 5000
          }
          volume_mount {
            name       = "pv-nexus"
            mount_path = "/nexus-data"
          }
          resources {
            requests = {
              cpu    = "4"
            }
          }
        }
        volume {
          name = "pv-nexus"
          persistent_volume_claim {
            claim_name = "pvc-nexus"
          }
        }
      }
    }
  }
  depends_on = [ kubernetes_namespace.tools-namespace ]
}
