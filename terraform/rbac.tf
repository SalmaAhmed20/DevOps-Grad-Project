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
resource "kubernetes_role" "role" {
  metadata {
    name      = "deployment-manager"
    namespace = "dev"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "role_binding" {
  metadata {
    name      = "jenkins-deployment-manager-binding"
    namespace = "dev"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-admin"
    namespace = "tools"
  }
}
