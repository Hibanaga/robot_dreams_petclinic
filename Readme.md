# HM 20 -> K8s

```textmate
    error: error validating "redis-stateful.yaml": error validating data: failed to download openapi: 
    Get "http://localhost:8080/openapi/v2?timeout=32s": dial tcp 127.0.0.1:8080: 
    connect: connection refused; if you choose to ignore these errors, 
    turn validation off with --validate=false

    brew install minikube
    hibana@mac robot_dreams_petclinic % kubectl get nodes
    NAME       STATUS   ROLES           AGE   VERSION
    minikube   Ready    control-plane   25s   v1.32.0

    hibana@mac robot_dreams_petclinic % kubectl apply -f redis-service.yaml 
    service/redis created
    hibana@mac robot_dreams_petclinic % kubectl apply -f redis-stateful.yaml 
    statefulset.apps/redis-stateful created
    
    hibana@mac robot_dreams_petclinic % kubectl config get-contexts
    CURRENT   NAME       CLUSTER    AUTHINFO   NAMESPACE
    *         minikube   minikube   minikube   default
              orbstack   orbstack   orbstack   
    hibana@mac robot_dreams_petclinic % kubectl config current-context
    minikube
```