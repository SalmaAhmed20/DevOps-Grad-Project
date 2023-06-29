resource "kubernetes_service" "jenkins-svc" {
  metadata {
    name = "jenkins-svc"
    namespace = kubernetes_namespace.tools-namespace.metadata.0.name
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

resource "kubernetes_service" "nexus-svc" {
  metadata {
    name = "nexus-svc"
    namespace = kubernetes_namespace.tools-namespace.metadata.0.name
  }
  spec {
    selector = {
      test = "nexus"
    }
    port {
      name = "http"
      port        = 8081
      target_port = 8081
      protocol = "TCP"
    }
    port {
      name = "docker"
      port        = 5000
      target_port = 5000
      protocol = "TCP"
    }
    type = "ClusterIP"
  }
}