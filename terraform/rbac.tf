resource "kubernetes_cluster_role" "jenkins-admin" {
  metadata {
    name = "jenkins-admin"
  }
  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
resource "kubernetes_service_account_v1" "jenkins-admin-sa" {
  automount_service_account_token = true
  metadata {
    name      = "jenkins-admin"
    namespace = kubernetes_namespace.tools-namespace.metadata.0.name
  }
}


resource "kubernetes_cluster_role_binding" "jenkins-admin-crb" {
  metadata {
    name = "jenkins-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.jenkins-admin-sa.metadata.0.name
    namespace = kubernetes_namespace.tools-namespace.metadata.0.name
  }
}
