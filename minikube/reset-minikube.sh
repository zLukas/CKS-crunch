
#!/bin/bash
# This script sets up Minikube with specific configurations for CKS certification preparation.

echo "setting up minikube"

minikube stop
minikube delete
minikube config set driver docker
minikube config set memory 6000
minikube config set cpus 4
minikube config set disk-size 20g
minikube config set kubernetes-version v1.31.0

minikube start