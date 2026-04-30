# AKS Management - Common Commands & Scripts

Quick reference guide for monitoring, debugging, scaling, and load balancing AKS clusters using Azure CLI and kubectl.

---

## Prerequisites

```bash
# Install Azure CLI
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

# Install kubectl
az aks install-cli

# Login to Azure
az login

# Set your subscription (if multiple subscriptions)
az account set --subscription "SUBSCRIPTION_ID"
```

---

## Cluster Connection & Configuration

### Get AKS Cluster Credentials
```bash
az aks get-credentials --resource-group aks-demof-rg --name aks-demo-cluster --overwrite-existing
```

### Verify Cluster Connection
```bash
kubectl cluster-info
```

### Get Current Context
```bash
kubectl config current-context
```

### List All Contexts
```bash
kubectl config get-contexts
```

### Switch Context
```bash
kubectl config use-context <context-name>
```

---

## Monitoring & Health Check

### Get Cluster Status
```bash
az aks show --resource-group aks-demof-rg --name aks-demo-cluster --query "powerState.code"
```

### Get All Nodes
```bash
kubectl get nodes
```

### Get Detailed Node Information
```bash
kubectl get nodes -o wide
```

### Check Node Resources (CPU/Memory)
```bash
kubectl top nodes
```

### Get Node Details with Taints and Labels
```bash
kubectl describe node <node-name>
```

### Monitor Pods Resource Usage
```bash
kubectl top pods --all-namespaces
```

### Check Pod Status Across All Namespaces
```bash
kubectl get pods --all-namespaces
```

### Get Pod Details
```bash
kubectl describe pod <pod-name> -n <namespace>
```

### Check Cluster Events
```bash
kubectl get events --all-namespaces --sort-by='.lastTimestamp'
```

### Monitor Cluster in Real-time
```bash
kubectl get pods --all-namespaces --watch
```

### Get Resource Quotas
```bash
kubectl get resourcequotas --all-namespaces
```

---

## Debugging & Troubleshooting

### View Pod Logs
```bash
kubectl logs <pod-name> -n <namespace>
```

### View Last 100 Lines of Logs
```bash
kubectl logs <pod-name> -n <namespace> --tail=100
```

### Stream Logs in Real-time
```bash
kubectl logs <pod-name> -n <namespace> -f
```

### View Previous Pod Logs (Crashed Pod)
```bash
kubectl logs <pod-name> -n <namespace> --previous
```

### Execute Command in Running Pod
```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash
```

### Copy File from Pod to Local
```bash
kubectl cp <namespace>/<pod-name>:/path/in/pod /local/path
```

### Copy File from Local to Pod
```bash
kubectl cp /local/path <namespace>/<pod-name>:/path/in/pod
```

### Check Pod Events and Errors
```bash
kubectl describe pod <pod-name> -n <namespace>
```

### Get Pod YAML Configuration
```bash
kubectl get pod <pod-name> -n <namespace> -o yaml
```

### View All Container Images in Cluster
```bash
kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq
```

### Find Pods by Image Name
```bash
kubectl get pods --all-namespaces -o jsonpath="{..image}" | grep "image-name"
```

### Debug Node Issues
```bash
kubectl debug node/<node-name> -it --image=ubuntu:latest
```

---

## Scaling Deployments & Nodes

### Scale Deployment (Pod Count)
```bash
kubectl scale deployment <deployment-name> --replicas=<number> -n <namespace>
```

### Get Horizontal Pod Autoscaler Status
```bash
kubectl get hpa --all-namespaces
```

### Watch HPA Activity
```bash
kubectl get hpa --all-namespaces --watch
```

### Create Horizontal Pod Autoscaler
```bash
kubectl autoscale deployment <deployment-name> --min=2 --max=10 --cpu-percent=70 -n <namespace>
```

### Check HPA Detailed Status
```bash
kubectl describe hpa <hpa-name> -n <namespace>
```

### Scale Node Pool (Azure CLI)
```bash
az aks nodepool scale --resource-group aks-demof-rg --cluster-name aks-demo-cluster --name <nodepool-name> --node-count <number>
```

### Get Node Pools
```bash
az aks nodepool list --resource-group aks-demof-rg --cluster-name aks-demo-cluster
```

### Add New Node Pool
```bash
az aks nodepool add --resource-group aks-demof-rg --cluster-name aks-demo-cluster --name <nodepool-name> --node-count 3
```

### Delete Node Pool
```bash
az aks nodepool delete --resource-group aks-demof-rg --cluster-name aks-demo-cluster --name <nodepool-name>
```

---

## Load Balancing & Service Management

### Get All Services
```bash
kubectl get svc --all-namespaces
```

### Get Service Details
```bash
kubectl describe svc <service-name> -n <namespace>
```

### Get Service Endpoints
```bash
kubectl get endpoints <service-name> -n <namespace>
```

### Get External IP of LoadBalancer Service
```bash
kubectl get svc <service-name> -n <namespace> -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Monitor Service Load Balancer
```bash
kubectl get svc --all-namespaces --watch
```

### Get Ingress Resources
```bash
kubectl get ingress --all-namespaces
```

### Get Ingress Details
```bash
kubectl describe ingress <ingress-name> -n <namespace>
```

### Test Service Connectivity
```bash
kubectl run test-pod --image=ubuntu --rm -it -- bash -c "apt-get update && apt-get install -y curl && curl http://<service-name>.<namespace>.svc.cluster.local"
```

### Port Forward to Service
```bash
kubectl port-forward svc/<service-name> 8080:80 -n <namespace>
```

### Port Forward to Pod
```bash
kubectl port-forward <pod-name> 8080:80 -n <namespace>
```

---

## Resource Management

### Get Resource Requests and Limits
```bash
kubectl get pods --all-namespaces -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,CPU_REQUEST:.spec.containers[*].resources.requests.cpu,MEM_REQUEST:.spec.containers[*].resources.requests.memory,CPU_LIMIT:.spec.containers[*].resources.limits.cpu,MEM_LIMIT:.spec.containers[*].resources.limits.memory
```

### Get Persistent Volume Claims
```bash
kubectl get pvc --all-namespaces
```

### Get Persistent Volumes
```bash
kubectl get pv
```

### Check Storage Class
```bash
kubectl get storageclass
```

---

## Networking & DNS

### Get Network Policies
```bash
kubectl get networkpolicy --all-namespaces
```

### Test DNS Resolution in Pod
```bash
kubectl run test-dns --image=ubuntu --rm -it -- bash -c "apt-get update && apt-get install -y dnsutils && nslookup kubernetes.default"
```

### Check Service DNS
```bash
kubectl run test-dns --image=ubuntu --rm -it -- bash -c "apt-get update && apt-get install -y dnsutils && nslookup <service-name>.<namespace>.svc.cluster.local"
```

### Get Cluster IP Range
```bash
az aks show --resource-group aks-demof-rg --name aks-demo-cluster --query "networkProfile.serviceCidr"
```

### Get Pod Network CIDR
```bash
az aks show --resource-group aks-demof-rg --name aks-demo-cluster --query "networkProfile.podCidr"
```

---

## Namespace Management

### Get All Namespaces
```bash
kubectl get namespaces
```

### Create Namespace
```bash
kubectl create namespace <namespace-name>
```

### Get Resources in Namespace
```bash
kubectl get all -n <namespace>
```

### Set Default Namespace
```bash
kubectl config set-context --current --namespace=<namespace>
```

### Delete Namespace
```bash
kubectl delete namespace <namespace>
```

---

## ACR (Azure Container Registry) Management

### List ACR Repositories
```bash
az acr repository list --name aksdemoacr
```

### List ACR Images in Repository
```bash
az acr repository show-tags --name aksdemoacr --repository <repo-name>
```

### Push Image to ACR
```bash
az acr build --registry aksdemoacr --image myapp:latest .
```

### Authenticate ACR with AKS
```bash
az aks update -n aks-demo-cluster -g aks-demof-rg --attach-acr aksdemoacr
```

---

## Azure CLI Cluster Management

### Get Cluster Information
```bash
az aks show --resource-group aks-demof-rg --name aks-demo-cluster
```

### List All AKS Clusters
```bash
az aks list --resource-group aks-demof-rg
```

### Update Cluster (Enable Monitoring)
```bash
az aks enable-addons --resource-group aks-demof-rg --name aks-demo-cluster --addons monitoring
```

### Update Cluster Autoscaler
```bash
az aks update --resource-group aks-demof-rg --name aks-demo-cluster --enable-cluster-autoscaler --min-count 1 --max-count 5
```

### Upgrade Cluster Kubernetes Version
```bash
az aks upgrade --resource-group aks-demof-rg --name aks-demo-cluster --kubernetes-version <version>
```

### Get Cluster Upgrades Available
```bash
az aks get-upgrades --resource-group aks-demof-rg --name aks-demo-cluster
```

---

## Useful One-Liners & Scripts

### Delete All Pods in Namespace
```bash
kubectl delete pods --all -n <namespace>
```

### Restart Deployment
```bash
kubectl rollout restart deployment/<deployment-name> -n <namespace>
```

### Check Deployment Rollout Status
```bash
kubectl rollout status deployment/<deployment-name> -n <namespace>
```

### Get All Resources by Label
```bash
kubectl get all -l <label-key>=<label-value> -n <namespace>
```

### Delete All Resources in Namespace
```bash
kubectl delete all --all -n <namespace>
```

### Get Resource Usage Summary
```bash
kubectl top nodes && echo "---" && kubectl top pods --all-namespaces
```

### Find All Pods Not Running
```bash
kubectl get pods --all-namespaces --field-selector=status.phase!=Running
```

### Get Pod Count by Namespace
```bash
kubectl get pods --all-namespaces --no-headers | awk '{print $1}' | sort | uniq -c
```

### Export All Resources to YAML
```bash
kubectl get all -A -o yaml > cluster-backup.yaml
```

### Check API Server Health
```bash
kubectl get componentstatus
```

---

## Useful Environment Variables (for scripting)

```bash
# Set these for easier command execution
RESOURCE_GROUP="aks-demof-rg"
CLUSTER_NAME="aks-demo-cluster"
NAMESPACE="default"
DEPLOYMENT_NAME="your-deployment"

# Use in commands like:
# kubectl scale deployment $DEPLOYMENT_NAME --replicas=3 -n $NAMESPACE
```

---

## Tips & Best Practices

1. **Always specify namespaces** in production: Use `-n <namespace>` to avoid affecting system namespaces
2. **Use labels** for resource organization and easy filtering
3. **Monitor resource limits** to prevent node pressure issues
4. **Implement Network Policies** for security
5. **Use Horizontal Pod Autoscalers** for automatic scaling
6. **Enable cluster autoscaling** to adjust node count automatically
7. **Regularly backup** your configuration using `kubectl get all -A -o yaml`
8. **Monitor cluster events** with `kubectl get events --all-namespaces`

---

## Additional Resources

- [Azure Kubernetes Service Documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Azure CLI AKS Commands](https://learn.microsoft.com/en-us/cli/azure/aks/)
