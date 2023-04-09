
# https://github.com/trstringer/trstringer.github.io/blob/main/_posts/2020-10-22-cheap-kubernetes-in-azure.md

resource_group=demo-admir
aks=demo
location=westeurope # az account list-locations

# az config set defaults.location=westeurope

MYACR=myContainerRegistry
az acr create -n $MYACR -g $resource_group --sku basic
az acr credential show -n $MYACR
# docker login $MYACR.azurecr.io --username $USR --password $PASS


# Create AKS
az group create --location $location --name $resource_group
az aks create \
    --resource-group $resource_group \
    --name $aks \
    --location $location \
    --node-count 1 \
    --load-balancer-sku basic \
    --node-vm-size "Standard_B2s" --attach-acr $MYACR
#   --network-plugin azure
#   --enable-managed-identity 
#   --max-pods 100 

az aks get-credentials --resource-group $resource_group --name $aks
# az aks browse --resource-group $resource_group --name $aks


# Deploy
az acr import -n $MYACR --source docker.io/library/nginx:latest --image nginx:v1
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx0-deployment
  labels:
    app: nginx0-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx0
  template:
    metadata:
      labels:
        app: nginx0
    spec:
      containers:
      - name: nginx
        image: $MYACR.azurecr.io/nginx:v1
        ports:
        - containerPort: 80
EOF

# Clean
az aks stop \
    --resource-group $resource_group \
    --name $aks
