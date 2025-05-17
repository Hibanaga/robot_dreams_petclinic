INSTANCE_ID ?= 0

apply:
	kubectl apply -f redis-pvcs.yaml
	kubectl apply -f redis-service.yaml
	kubectl apply -f redis-stateful.yaml
delete:
	kubectl delete statefulset redis-stateful --ignore-not-found
	kubectl delete service redis --ignore-not-found
	kubectl delete pvc --ignore-not-found
	kubectl delete pvc redis-backup-pvc --ignore-not-found

recreate: delete apply

status:
	kubectl get pods
	kubectl get pvc

exec:
	kubectl exec -it redis-stateful-$(INSTANCE_ID) -- redis-cli