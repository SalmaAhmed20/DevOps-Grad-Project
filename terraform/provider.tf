terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}
provider "kubernetes" {
  config_path    = var.config_path
  config_context = "minikube"
}