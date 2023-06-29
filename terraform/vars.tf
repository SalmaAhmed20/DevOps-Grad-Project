variable "config_path" {
    type = string
}
# minikube ssh -- cat /etc/resolv.conf
variable "nameserver" {
  type = list(string)
}
variable "search" {
    type = list(string)
}
variable "options" {
    type = list(string)
}
#minikube addons enable ingress