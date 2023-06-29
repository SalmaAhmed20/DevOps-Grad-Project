resource "kubernetes_ingress_v1" "nexus" {
  metadata {
    name = "nexus"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "0"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "600"
    }
    namespace = "tools"
  }
  spec {
    rule {
      host = "nexus.local.com"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "nexus-svc"
              port {
                number = 8081
              }
            }

          }
        }
      }
    }
    rule {
      host = "docker.nexus.local.com"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "nexus-svc"
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
