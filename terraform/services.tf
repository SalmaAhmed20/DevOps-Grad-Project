resource "kubernetes_service" "jenkins-svc" {
  metadata {
    name = "jenkins-svc"
    namespace = "tools"
  }
  spec {
    selector = {
      test = "jenkins"
    }
    port {
      port        = 8080
      target_port = 8080
      protocol = "TCP"
    }
    type = "NodePort"
  }
}
