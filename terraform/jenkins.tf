resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.tools-namespace.metadata.0.name
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
        service_account_name = kubernetes_service_account_v1.jenkins-admin-sa.metadata.0.name
        container {
          image = "salma22/jenkinsdockerkubectl"
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
          nameservers = var.nameserver
          searches    = var.search
          option {
            name  = var.options[0]
            value = 0
          }
          option {
            name = var.options[1]
          }
          option {
            name = var.options[2]
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
  depends_on = [ kubernetes_service_account_v1.jenkins-admin-sa, kubernetes_namespace.tools-namespace ]
}
