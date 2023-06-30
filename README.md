# DevOps Graduation Project

The project is a try to use all Dev & Ops tools to\
1- setup a Kubernetes cluster **minikube** using **Ansible**\
2- Create Kubernetes resources **nexus** and **jenkins** using **Terraform**\
3- **nexus** for private docker registry\
4- **jenkins** for CI and will push docker image to **nexus** and CD will deploy app to Kubernetes cluster **minikube**\
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

![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/9842e39f-2999-48e9-ae51-607e7439d20d)

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
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/210dee67-d2f3-4c88-9a7b-4a624d30203f)

```
minikube service list
```
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/513998b6-4608-44a1-b7e7-873d33778bd4)

## Jenkins
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/8b706c39-1e94-44bc-890c-ba699787c991)

```
kubectl exec <podname> -n tools cat /var/jenkins_home/secrets/initialAdminPassword
```
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/7a2487c8-afa3-4bcb-a887-ff609df5d83e)
## nexus
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/08078b03-28bb-49ee-bfc7-cf3b90d56cc9)

![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/f673b1e0-dca5-446f-8f50-9d7eba1e602a)

```
kubectl exec  <podname> -n tools cat /nexus-data/admin.password
```
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/0961d1d5-27aa-49e7-80d7-0594713e709a)
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/f49c4ebe-6faa-44ba-b703-5b10e19f9cf7)

### Create a new  docker hosted Repo
![image](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/02a6fab2-f40d-4da9-9d4f-f5fbab50af1e)
### After Pushing to nexus from jenkins CI 
![Screenshot from 2023-06-30 18-12-57](https://github.com/SalmaAhmed20/DevOps-Grad-Project/assets/64385957/0c31930a-5c0e-4cdf-9cc3-b623feced306)

