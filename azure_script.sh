#!/bin/bash

# VARIABLES - customize these
RESOURCE_GROUP="FlaskAuthRG"
ACR_NAME="flaskauthacr2"
AKS_CLUSTER_NAME="flaskappcluster"
APP_NAME="flaskapp"
# LOCAL_IMAGE_NAME="sit753_hd-flaskapp:latest"
LOCAL_IMAGE_NAME="hd_pipeline-flaskapp:latest"
DOCKER_IMAGE="$ACR_NAME.azurecr.io/$APP_NAME:v1"

# Create a resource group
az group create --name $RESOURCE_GROUP --location centralus

# Create an Azure Container Registry
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

# Log in to the Azure Container Registry
az acr login --name $ACR_NAME

# # Tag the local image
docker tag $LOCAL_IMAGE_NAME $DOCKER_IMAGE

# # Push the image to the Azure Container Registry
docker push $DOCKER_IMAGE

# Check whether the image is in the ACR
az acr repository list --name $ACR_NAME --output table



# Create an Azure Kubernetes Service (AKS) cluster
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --node-count 1 \
    --node-vm-size Standard_D2als_v6 \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 2 \
    --generate-ssh-keys


# az provider register --namespace Microsoft.ContainerInstance
az acr repository list --name $ACR_NAME --output table


# Get the AKS credentials
# az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

# # Attach the ACR to the AKS cluster
az aks update --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --attach-acr $ACR_NAME


# Create a Kubernetes deployment
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
      - name: $APP_NAME
        image: $DOCKER_IMAGE
        ports:
        - containerPort: 5000
EOF

# Create Kubernetes Service YAML file
cat <<EOF > service.yaml
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 5000
    protocol: TCP
  selector:
    app: $APP_NAME
EOF

# Deploy the app to AKS
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Watch the service to get the external IP
echo "Waiting for external IP..."
kubectl get service $APP_NAME-service


