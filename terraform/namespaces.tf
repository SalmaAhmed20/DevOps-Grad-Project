resource "kubernetes_namespace" "tools-namespace" {
  metadata {
    name = "tools"
  }
}
resource "kubernetes_namespace" "dev-namespace" {
  metadata {
    name = "dev"
  }
}