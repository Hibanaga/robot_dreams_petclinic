# HM 20 -> K8s

## Pre-requires:
```textmate
Тут трошки логів і контексту з чим спочатку трошки було не зрозуміло, 
що і куди танцювати, але в цілому коли розібратись з контекстом виконання
вже не так складно.
```

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
    
    hibana@mac robot_dreams_petclinic % kubectl config use-context orbstack
    Switched to context "orbstack".
    hibana@mac robot_dreams_petclinic % kubectl config get-contexts        
    CURRENT   NAME       CLUSTER    AUTHINFO   NAMESPACE
              minikube   minikube   minikube   default
    *         orbstack   orbstack   orbstack   
```

## Завдання 1: Створення StatefulSet для Redis-кластера ([helpful source](https://portal.nutanix.com/page/documents/solutions/details?targetId=TN-2194-Deploying-Redis-Nutanix-Data-Services-Kubernetes:creating-the-redis-application-with-a-statefulset.html))
Кроки:
1. Створіть PersistentVolumeClaim (PVC) для зберігання даних Redis. Кожен под у StatefulSet використовуватиме свій окремий том для зберігання даних.
2. Створіть StatefulSet для Redis із налаштуваннями для запуску двох реплік. Кожна репліка повинна мати стабільне ім’я та доступ до постійного тому.
3. Створіть Service для Redis: Service для StatefulSet потрібен для доступу до Redis. Використовуйте тип Service ClusterIP для внутрішньої взаємодії між подами.
4. Перевірка роботи: після створення StatefulSet перевірте, чи запущені поди (kubectl get pods) і чи мають вони стабільні імена, наприклад, redis-0, redis-1. Застосовуйте команду kubectl exec для підключення до кожного пода та перевірки збереження даних між перезапусками.

```redis-stateful.yaml```
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-stateful
  labels:
    app: redis
spec:
  serviceName: "redis"
  replicas: 2
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      terminationGracePeriodSeconds: 30
      securityContext:
        fsGroup: 1004
      containers:
        - name: redis
          image: redis:alpine
          command: ["redis-server"]
          args:
            - "--port"
            - "6379"
            - "--dir"
            - "/mnt/redis/data"
            - "--appendonly"
            - "yes"
          ports:
            - containerPort: 6379
          volumeMounts:
            - name: redis-data
              mountPath: /mnt/redis/data
      volumes:
        - name: redis-data
          persistentVolumeClaim:
            claimName: redis-data-pvc
  volumeClaimTemplates:
    - metadata:
        name: redis-data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi
```

``` redis-service.yaml ```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  labels:
    app: redis
spec:
  ports:
    - port: 6379
      name: redis
  clusterIP: None
  selector:
    app: redis
```

```Makefil```

```text
Для спрощеного використання поміж 
перезапусками створеннями і т.д.
```

```makefile
ID ?= 0

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
```

## Logs:
```large_log
hibana@mac robot_dreams_petclinic % make delete
kubectl delete statefulset redis-stateful --ignore-not-found
statefulset.apps "redis-stateful" deleted
kubectl delete service redis --ignore-not-found
service "redis" deleted
kubectl delete pvc redis-backup-pvc --ignore-not-found
hibana@mac robot_dreams_petclinic % make delete
kubectl delete statefulset redis-stateful --ignore-not-found
kubectl delete service redis --ignore-not-found
kubectl delete pvc -l app=redis --ignore-not-found
persistentvolumeclaim "redis-data-redis-stateful-0" deleted
persistentvolumeclaim "redis-data-redis-stateful-1" deleted
hibana@mac robot_dreams_petclinic % make apply
kubectl apply -f redis-service.yaml
service/redis created
kubectl apply -f redis-stateful.yaml
statefulset.apps/redis-stateful created
hibana@mac robot_dreams_petclinic % make status
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
redis-stateful-0   1/1     Running   0          12s
redis-stateful-1   1/1     Running   0          9s
kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
redis-data-redis-stateful-0   Bound    pvc-c1f2d485-e92c-41f5-ac29-2b4cf16789aa   1Gi        RWO            local-path     <unset>                 12s
redis-data-redis-stateful-1   Bound    pvc-362b6d73-350e-435d-a965-8fbee6ca0483   1Gi        RWO            local-path     <unset>                 9s
hibana@mac robot_dreams_petclinic % make exec ID=0
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> keys *
(empty array)
127.0.0.1:6379> set hello world
OK
127.0.0.1:6379> set hello-1 world-1
OK
127.0.0.1:6379> exit
hibana@mac robot_dreams_petclinic % make exec ID=1
kubectl exec -it redis-stateful-1 -- redis-cli
127.0.0.1:6379> set world hello
OK
127.0.0.1:6379> set world-1 hello-1
OK
127.0.0.1:6379> keys
(error) ERR wrong number of arguments for 'keys' command
127.0.0.1:6379> keys *
1) "world"
2) "world-1"
127.0.0.1:6379> 
hibana@mac robot_dreams_petclinic % make status   
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
redis-stateful-0   1/1     Running   0          61s
redis-stateful-1   1/1     Running   0          58s
kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
redis-data-redis-stateful-0   Bound    pvc-c1f2d485-e92c-41f5-ac29-2b4cf16789aa   1Gi        RWO            local-path     <unset>                 61s
redis-data-redis-stateful-1   Bound    pvc-362b6d73-350e-435d-a965-8fbee6ca0483   1Gi        RWO            local-path     <unset>                 58s
hibana@mac robot_dreams_petclinic % orb stop
hibana@mac robot_dreams_petclinic % orb start
hibana@mac robot_dreams_petclinic % make status
kubectl get pods
NAME               READY   STATUS    RESTARTS      AGE
redis-stateful-0   1/1     Running   1 (31s ago)   96s
redis-stateful-1   1/1     Running   1 (31s ago)   93s
kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
redis-data-redis-stateful-0   Bound    pvc-c1f2d485-e92c-41f5-ac29-2b4cf16789aa   1Gi        RWO            local-path     <unset>                 96s
redis-data-redis-stateful-1   Bound    pvc-362b6d73-350e-435d-a965-8fbee6ca0483   1Gi        RWO            local-path     <unset>                 93s
hibana@mac robot_dreams_petclinic % make exec ID=0
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> keys *
1) "hello-1"
2) "hello"
127.0.0.1:6379> exit
hibana@mac robot_dreams_petclinic % make exec ID=1
kubectl exec -it redis-stateful-1 -- redis-cli
127.0.0.1:6379> keys *
1) "world"
2) "world-1"
127.0.0.1:6379> exit
```

## Post-run with 4 replicas
```large_log
hibana@mac robot_dreams_petclinic % make exec 0
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> set hello world
OK
127.0.0.1:6379> exit
make: *** No rule to make target `0'.  Stop.
hibana@mac robot_dreams_petclinic % make exec 1
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> set hello-1 world-1
OK
127.0.0.1:6379> exit
make: *** No rule to make target `1'.  Stop.
hibana@mac robot_dreams_petclinic % make exec 2
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> set hello-2 world-2
OK
127.0.0.1:6379> 
make: *** No rule to make target `2'.  Stop.
hibana@mac robot_dreams_petclinic % make exec 3 
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> set hello-3
(error) ERR wrong number of arguments for 'set' command
127.0.0.1:6379> set hello-3 world-3
OK
127.0.0.1:6379> exit
make: *** No rule to make target `3'.  Stop.
hibana@mac robot_dreams_petclinic % orb stop
hibana@mac robot_dreams_petclinic % orb status
Stopped
hibana@mac robot_dreams_petclinic % orb start
hibana@mac robot_dreams_petclinic % make status
kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
redis-stateful-0   1/1     Running   0          3m29s
redis-stateful-1   1/1     Running   0          3m24s
redis-stateful-2   1/1     Running   0          3m19s
redis-stateful-3   1/1     Running   0          3m14s
kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
redis-data-redis-stateful-0   Bound    pvc-b0a35ad9-1a44-46c1-a978-70a632d5a46d   1Gi        RWO            local-path     <unset>                 3m29s
redis-data-redis-stateful-1   Bound    pvc-f242cb89-08be-4f2b-8d96-5ca604ce42ce   1Gi        RWO            local-path     <unset>                 3m24s
redis-data-redis-stateful-2   Bound    pvc-28bad177-87ea-4cd3-a84f-e51f1c20e8c5   1Gi        RWO            local-path     <unset>                 3m19s
redis-data-redis-stateful-3   Bound    pvc-35bcc5bd-0d8c-4bc6-a47f-16d3328d4a08   1Gi        RWO            local-path     <unset>                 3m14s
hibana@mac robot_dreams_petclinic % make exec 0
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> keys *
1) "hello-2"
2) "hello-1"
3) "hello-3"
4) "hello"
127.0.0.1:6379> exit
make: *** No rule to make target `0'.  Stop.
hibana@mac robot_dreams_petclinic % make exec 1
kubectl exec -it redis-stateful-0 -- redis-cli
127.0.0.1:6379> keys *
1) "hello-2"
2) "hello-1"
3) "hello-3"
4) "hello"
127.0.0.1:6379> 
```

📌 Завдання 2: Налаштування Falco в Kubernetes за допомогою DaemonSet [source](https://github.com/sysdiglabs/falco-nats/blob/master/falco-daemonset-configmap.yaml)

Мета завдання

Розгорнути інструмент Falco в кластері Kubernetes для моніторингу подій безпеки на кожному вузлі. Falco буде встановлено через DaemonSet, що забезпечить його запуск на кожному вузлі в кластері для контролю системних подій у реальному часі.

Кроки

1. Налаштуйте DaemonSet для Falco:
* Розробіть конфігурацію DaemonSet, яка розгорне Falco на кожному вузлі. Falco повинен працювати з привілейованим доступом для моніторингу системних викликів.
2. Налаштуйте монтування системних директорій: для того, щоб Falco міг правильно збирати системні події, потрібно змонтувати такі директорії:
* /proc — директорія, що містить інформацію про запущені процеси, це треба для доступу до процесів на вузлі
* /boot — може містити дані про конфігурації ядра, що дає змогу Falco краще розпізнавати події
* /lib/modules — тут розташовані модулі ядра, доступ до них дозволяє Falco використовувати eBPF для збору даних
* /var/run/docker.sock — дає Falco доступ до Docker-сокета для контролю подій, пов’язаних з контейнерами — важливо, якщо вузол використовує Docker як рантайм
* /usr — дозволяє доступ до системних бібліотек і утиліт, необхідних для розширення функціональності Falco
3. Обмежте використання ресурсів:
* Для Falco потрібно встановити обмеження на застосування ресурсів (CPU і пам’ять), щоб він не впливав на роботу інших сервісів на вузлі
* Встановіть, наприклад, 100m CPU і 256Mi пам’яті як ліміти, а також 100m CPU і 128Mi пам’яті як мінімальні запити
4. Створіть YAML-файл конфігурації DaemonSet:
* Створіть YAML-файл, який відповідає вимогам і запускає Falco на кожному вузлі
* Переконайтеся, що всі потрібні директорії змонтовані для коректної роботи Falco
5. Перевірка розгортання та роботи Falco:
   Після застосування YAML-файлу за допомогою команди kubectl apply -f falco-daemonset.yaml
* Перевірте, чи всі поди Falco запущені на кожному вузлі: kubectl get pods -l app=falco -n kube-system
* Переконайтеся, що кожен под Falco працює в статусі Running
6. Виконайте команду для перегляду логів одного з подів Falco: kubectl logs -l app=falco -n kube-system
* Переконайтеся, що Falco генерує сповіщення про події — логи можуть містити інформацію про такі дії, як-от доступ до файлів, створення нових процесів або взаємодія з Docker

