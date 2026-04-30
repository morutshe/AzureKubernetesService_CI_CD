
#!/bin/bash
REGION="southafricanorth"
RGP="aks-demof-rg"
CLUSTER_NAME="aks-demo-cluster"
ACR_NAME="aksdemoacr"
SQLSERVER="aks-demo-sqlserver"
DB="mhcdb"


 #Create Resource group
 az group create --name $RGP --location $REGION

#Deploy AKS
az aks create --resource-group $RGP --name $CLUSTER_NAME --enable-addons monitoring --generate-ssh-keys --location $REGION

#Deploy ACR
az acr create --resource-group $RGP --name $ACR_NAME --sku Standard --location $REGION

#Authenticate with ACR to AKS
az aks update -n $CLUSTER_NAME -g $RGP --attach-acr $ACR_NAME

#Create SQL Server and DB
az sql server create -l $REGION -g $RGP -n $SQLSERVER -u sqladmin -p P2ssw0rd1234

az sql db create -g $RGP -s $SQLSERVER -n $DB --service-objective S0
