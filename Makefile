delete-nginx:
	kubectl delete configmap nginx-index --ignore-not-found
	kubectl delete service nginx-deployment --ignore-not-found
	kubectl delete deployment nginx-deployment --ignore-not-found

delete-all:
	kubectl delete all --all --ignore-not-found
	kubectl delete pvc --all --ignore-not-found
	kubectl delete configmap --all --ignore-not-found