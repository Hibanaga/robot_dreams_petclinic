ID ?= 0

# Redis -> stateful set
apply:
	kubectl apply -f redis-service.yaml
	kubectl apply -f redis-stateful.yaml
delete:
	kubectl delete statefulset redis-stateful --ignore-not-found
	kubectl delete service redis --ignore-not-found
	kubectl delete pvc -l app=redis --ignore-not-found

recreate: delete apply

status:
	kubectl get pods
	kubectl get pvc

exec:
	kubectl exec -it redis-stateful-$(ID) -- redis-cli

# Falco -> daemon set
falco-apply:
	kubectl apply -f falco-account.yaml
	kubectl apply -f falco-daemon.yaml
falco-delete:
	kubectl delete daemonset falco -n kube-system --ignore-not-found
	kubectl delete serviceaccount falco-account -n kube-system --ignore-not-found
	kubectl delete clusterrole  falco-cluster-role --ignore-not-found
	kubectl delete clusterrolebinding falco-cluster-role-binding --ignore-not-found
falco-recreate: falco-delete falco-apply
falco-status:
	kubectl get pods -n kube-system -l app=falco
falco-logs:
	kubectl logs -l app=falco -n kube-system --tail=100
falco-describe:
	kubectl describe daemonset falco -n kube-system
falco-logs:
	kubectl logs -n kube-system -l app=falco

helm-namespace:
	helm list --all-namespaces

helm-apply:
	kubectl delete pod redis-client -n default --ignore-not-found
	REDIS_PASSWORD=$$(kubectl get secret --namespace default redis-stateful -o jsonpath="{.data.redis-password}" | base64 -d) && \
	kubectl run redis-client \
	  --namespace default \
	  --restart='Never' \
	  --env REDIS_PASSWORD=$$REDIS_PASSWORD \
	  --image docker.io/bitnami/redis:8.0.1-debian-12-r1 \
	  --command -- sleep infinity
helm-exec:
	kubectl exec -it redis-client -n default -- bash
helm-exec-master:
	REDIS_PASSWORD=$$(kubectl get secret --namespace default redis-stateful -o jsonpath="{.data.redis-password}" | base64 -d) && \
	kubectl exec -it redis-client -n default -- bash -c "REDISCLI_AUTH=$$REDIS_PASSWORD redis-cli -h redis-stateful-master"

helm-client-delete:
	helm uninstall redis-stateful --ignore-not-found
	kubectl delete service redis-client --ignore-not-found
	kubectl delete deployment redis-client --ignore-not-found
	kubectl delete pvc -l app=redis-client --ignore-not-found
	kubectl delete secret redis-stateful --ignore-not-found

helm-client-apply:
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo update
	helm install redis-stateful bitnami/redis --set replica.replicaCount=2
	kubectl apply -f redis-client.yaml
	kubectl apply -f redis-client-service.yaml

helm-client-recreate: helm-client-delete helm-client-apply

helm-client-exec:
	REDIS_PASSWORD=$$(kubectl get secret --namespace default redis-stateful -o jsonpath="{.data.redis-password}" | base64 -d) && \
	kubectl exec --stdin --tty redis-client-0 -- bash -c "REDISCLI_AUTH=$$REDIS_PASSWORD redis-cli -h redis-stateful-master"


