resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "tools"
    labels = {
      test = "jenkins"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        test = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          test = "jenkins"
        }
      }
      spec {
        container {
          image = "salma22/jenkinswithdocker"
          name  = "jenkins"

          port {
            container_port = 8080
          }
          volume_mount {
            name       = "pv-jenkins"
            mount_path = "/var/jenkins_home"
          }
          volume_mount {
            name       = "docker"
            mount_path = "/var/run"
          }
          liveness_probe {
            http_get {
              path = "/login"
              port = 8080
            }
            initial_delay_seconds = 90
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 5
          }
        }
        dns_config {
          nameservers = ["192.168.49.1"]
          searches    = ["domain.name"]
          option {
            name  = "ndots"
            value = 0
          }
          option {
            name = "trust-ad"
          }
          option {
            name = "edns0"
          }
        }

        dns_policy = "None"
        volume {
          name = "pv-jenkins"
          persistent_volume_claim {
            claim_name = "pvc-jenkins"
          }
        }
        volume {
          name = "docker"
          host_path {
            path = "/var/run"
          }
        }
      }
    }
  }
}