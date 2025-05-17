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