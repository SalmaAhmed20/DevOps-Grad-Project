# DevOps Graduation Project

The project is a try to use all Dev & Ops tools to\
1- setup a Kubernetes cluster **minikube** using **Ansible**\
2- Create Kubernetes resources **nexus** and **jenkins** using **Terraform**\
3- **nexus** for private docker registry\
4- **jenkins** for CI and will push docker image to **nexus** and CD will deploy app to Kubernetes cluster **minikube**
5- **docker** as container runtime engine
## Ansible
Prerequisite
```
ssh-keygen
```
```
cat ~/.ssh/id_rsa.pub >  ~/.ssh/authorized_keys 
```
- Create an ansible role
- in tasks
  - Check for dependencies (driver need for minikube)
  - Download and install Minikube
  - Start Minikube with Docker driver
  - install Minikube addons (ingress)
```
.
└── ansible
    ├── minikube
    │   ├── tasks
    │   │   └── main.yaml
    │   └── vars
    │       └── main.yaml
    ├── ansible.cfg
    ├── inventory
    └── minikube.yaml
```

```
ansible-playbook -i inventory minikube.yaml --ask-become-pass
```


![6d12e701-11f3-4f6b-bac4-70d94f193221](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/5cb2e023-66a3-4584-ad2e-077a06f67f6b)\
**You need to ssh to minikube and create ~/nexus-data directroy and change permission to avoid any error**\
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/0a6cb2e6-552e-4f64-936d-c86721ce6623)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
## Docker
Using **Docker** in\
1- Create customized [Jenkins Docker image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/dockerfile) contain Docker Cli and Kubectl tool\
```
docker builed -t <username>/jenkinswithdockerkubecl .
```
2- Create Docker Image for the application 
## Terraform
using Terraform provising tool in **IaC**, Create Kubernetes resources using\
- Create [Cluster Role and Cluster Role Binding](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/rbac.tf)
- Create [Persistent volumes](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/volume.tf)
- Create 2 [namespaces](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/namespaces.tf)
  - tools
  - dev
- in **tools** namespace 
  - deploy [Jenkins](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/jenkins.tf) "customized docker image"
  - attach deploy to persistent volume using [Persistent Volume Claim](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/claims.tf)
  - Give Jenkins service account to be able to access cluster\
    [Persistent Volume Claim, Deployment,Serivce ,Service Account]
  - deploy [nexus](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/nexus.tf)
  - attach deploy to persistent volume using [Persistent Volume Claim](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/claims.tf)\
    [Persistent Volume Claim, Deployment,Serivce ,[ingress](https://github.com/SalmaAhmed20/DevOps-Grad-Project/blob/main/terraform/ingress.tf)]
```
terraform init
```
![Screenshot from 2023-06-30 16-32-37](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/d42733e1-0711-4f0e-b8ab-d2dc93c7a04e)
```
terraform apply
```
![grad-project drawio](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/f1feb31e-b98b-4974-8276-8c1e425553f6)
![Screenshot from 2023-06-30 17-04-16](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/51e7849d-0c73-4642-b889-512f857f2767)
![Screenshot from 2023-06-30 17-05-40](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/aec146d3-9d9b-4ae6-b885-b6d66fb7d74e)
```
kubectl get po -n tools
```
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/5e2346ba-67bd-4069-a755-b6000ff7a07b)
```
minikube service list
```
![Screenshot from 2023-06-30 17-14-07](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/8745eb78-67c0-471d-8675-b747fec48874)
## Jenkins
```
kubectl exec <podname> -n tools cat /var/jenkins_home/secrets/initialAdminPassword`
```
![Screenshot from 2023-06-30 17-13-45](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/d11eb65e-d1c0-4832-955f-40b26cf91421)
## nexus
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/08078b03-28bb-49ee-bfc7-cf3b90d56cc9)

![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/f673b1e0-dca5-446f-8f50-9d7eba1e602a)

```
kubectl exec  <podname> -n tools cat /nexus-data/admin.password
```
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/66c87997-7a71-45c9-b3dc-2dde91e49fd3)
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/a4dbe5c9-6c98-4fce-858d-40a67105f5af)

### Create a new  docker hosted Repo
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/02a6fab2-f40d-4da9-9d4f-f5fbab50af1e)
### After Pushing to nexus from jenkins CI 
![Screenshot from 2023-06-30 18-12-57](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/0c31930a-5c0e-4cdf-9cc3-b623feced306)

