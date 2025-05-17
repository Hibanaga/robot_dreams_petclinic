# HM 20 -> K8s

## Pre-requires:
```textmate
Тут трохи логів і контексту — спочатку було не зовсім зрозуміло, 
що і як налаштовувати, але загалом, коли розібратися з контекстом виконання, 
усе вже не здається таким складним. 

Також виконання першого і другого завдань 
відбувалося в різних середовищах:

1. За допомогою OrbStack
2. За допомогою Minikube

Тому що чомусь OrbStack працює дуже погано і він має обмежений функціонал,
або ж я просто погано налаштував, що теж можливо(
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

## Завдання 1: Створення StatefulSet для Redis-кластера 

Корисний ресурс на основі якого було створено redis-stateful.yaml: ([source](https://portal.nutanix.com/page/documents/solutions/details?targetId=TN-2194-Deploying-Redis-Nutanix-Data-Services-Kubernetes:creating-the-redis-application-with-a-statefulset.html))
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

```Makefilе```

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

📌 Завдання 2: Налаштування Falco в Kubernetes за допомогою DaemonSet 

Мета завдання
Розгорнути інструмент Falco в кластері Kubernetes для моніторингу подій безпеки на кожному вузлі. Falco буде встановлено через DaemonSet, що забезпечить його запуск на кожному вузлі в кластері для контролю системних подій у реальному часі.


Корисний ресурс, в якому було описано 80% всього конфігу: [source](https://github.com/sysdiglabs/falco-nats/blob/master/falco-daemonset-configmap.yaml)

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

```makefile
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
```

```falco-account.yaml```
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: falco-account
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: falco-cluster-role
rules:
  - apiGroups: ["extensions",""]
    resources: ["nodes","namespaces","pods","replicationcontrollers","services","events","configmaps"]
    verbs: ["get","list","watch"]
  - nonResourceURLs: ["/healthz", "/healthz/*"]
    verbs: ["get"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: falco-cluster-role-binding
  namespace: default
subjects:
  - kind: ServiceAccount
    name: falco-account
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: falco-cluster-role
  apiGroup: rbac.authorization.k8s.io
```

```falco-daemon.yaml```
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: falco
  namespace: kube-system
  labels:
    app: falco
spec:
  selector:
    matchLabels:
      app: falco
  template:
    metadata:
      labels:
        app: falco
        role: security
    spec:
      serviceAccountName: falco-account
      containers:
        - name: falco
          image: falcosecurity/falco:latest
          imagePullPolicy: Always
          resources:
            limits:
              cpu: 100m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi
          securityContext:
            privileged: true
          volumeMounts:
            - name: shared-pipe
              mountPath: /var/run/falco
              readOnly: false
            - name: docker-socket
              mountPath: /host/var/run/docker.sock
              readOnly: true
            - name: dev-fs
              mountPath: /host/dev
              readOnly: true
            - name: proc-fs
              mountPath: /host/proc
              readOnly: true
            - name: boot-fs
              mountPath: /host/boot
              readOnly: true
            - name: lib-modules
              mountPath: /host/lib/modules
              readOnly: true
            - name: user-fs
              mountPath: /host/usr
              readOnly: true
      initContainers:
        - name: init-pipe
          image: busybox
          command:
            - sh
            - -c
            - "mkfifo /var/run/falco/nats"
          volumeMounts:
            - name: shared-pipe
              mountPath: /var/run/falco/
              readOnly: false
      volumes:
        - name: shared-pipe
          emptyDir: {}
        - name: docker-socket
          hostPath:
            path: /var/run/docker.sock
        - name: dev-fs
          hostPath:
            path: /dev
        - name: proc-fs
          hostPath:
            path: /proc
        - name: boot-fs
          hostPath:
            path: /boot
        - name: lib-modules
          hostPath:
            path: /lib/modules
        - name: user-fs
          hostPath:
            path: /usr
```

## Creation Logs
```text
kubectl get pods -n kube-system -l app=falco
NAME          READY   STATUS    RESTARTS   AGE
falco-mnwcm   1/1     Running   0          4m46s

hibana@mac robot_dreams_petclinic % make falco-describe
Makefile:39: warning: overriding commands for target `falco-logs'
Makefile:35: warning: ignoring old commands for target `falco-logs'
kubectl describe daemonset falco -n kube-system
Name:           falco
Namespace:      kube-system
Selector:       app=falco
Node-Selector:  <none>
Labels:         app=falco
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=falco
                    role=security
  Service Account:  falco-account
  Init Containers:
   init-pipe:
    Image:      busybox
    Port:       <none>
    Host Port:  <none>
    Command:
      sh
      -c
      mkfifo /var/run/falco/nats
    Environment:  <none>
    Mounts:
      /var/run/falco/ from shared-pipe (rw)
  Containers:
   falco:
    Image:      falcosecurity/falco:latest
    Port:       <none>
    Host Port:  <none>
    Limits:
      cpu:     100m
      memory:  256Mi
    Requests:
      cpu:        100m
      memory:     128Mi
    Environment:  <none>
    Mounts:
      /host/boot from boot-fs (ro)
      /host/dev from dev-fs (ro)
      /host/lib/modules from lib-modules (ro)
      /host/proc from proc-fs (ro)
      /host/usr from user-fs (ro)
      /host/var/run/docker.sock from docker-socket (ro)
      /var/run/falco from shared-pipe (rw)
  Volumes:
   shared-pipe:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
   docker-socket:
    Type:          HostPath (bare host directory volume)
    Path:          /var/run/docker.sock
    HostPathType:  
   dev-fs:
    Type:          HostPath (bare host directory volume)
    Path:          /dev
    HostPathType:  
   proc-fs:
    Type:          HostPath (bare host directory volume)
    Path:          /proc
    HostPathType:  
   boot-fs:
    Type:          HostPath (bare host directory volume)
    Path:          /boot
    HostPathType:  
   lib-modules:
    Type:          HostPath (bare host directory volume)
    Path:          /lib/modules
    HostPathType:  
   user-fs:
    Type:          HostPath (bare host directory volume)
    Path:          /usr
    HostPathType:  
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age    From                  Message
  ----    ------            ----   ----                  -------
  Normal  SuccessfulCreate  5m40s  daemonset-controller  Created pod: falco-mnwcm
```

## Trying make some actions
```text
hibana@mac robot_dreams_petclinic % make falco-logs                                              
Makefile:39: warning: overriding commands for target `falco-logs'
Makefile:35: warning: ignoring old commands for target `falco-logs'
kubectl logs -n kube-system -l app=falco
Defaulted container "falco" out of: falco, init-pipe (init)
2025-05-17T10:44:28+0000: System info: Linux version 6.13.7-orbstack-00283-g9d1400e7e9c6 (orbstack@builder) (ClangBuiltLinux clang version 19.1.4 (https://github.com/llvm/llvm-project.git aadaa00de76ed0c4987b97450dd638f63a385bed), ClangBuiltLinux LLD 19.1.4 (https://github.com/llvm/llvm-project.git aadaa00de76ed0c4987b97450dd638f63a385bed)) #104 SMP Mon Mar 17 06:15:48 UTC 2025
2025-05-17T10:44:28+0000: Loading rules from:
2025-05-17T10:44:29+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2025-05-17T10:44:29+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2025-05-17T10:44:29+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2025-05-17T10:44:29+0000: Starting health webserver with threadiness 12, listening on 0.0.0.0:8765
2025-05-17T10:44:29+0000: Loaded event sources: syscall
2025-05-17T10:44:29+0000: Enabled event sources: syscall
2025-05-17T10:44:29+0000: Opening 'syscall' source with modern BPF probe.
2025-05-17T10:44:29+0000: One ring buffer every '2' CPUs.
hibana@mac robot_dreams_petclinic % kubectl run shelltest --rm -i --tty --image=alpine -- /bin/sh

If you don't see a command prompt, try pressing enter.

/ # # touch /bin/evil_script.sh
/ # touch /bin/evil_script.sh
/ # chmod +x /bin/evil_script.sh
/ # exit
Session ended, resume using 'kubectl attach shelltest -c shelltest -i -t' command when the pod is running
pod "shelltest" deleted
hibana@mac robot_dreams_petclinic % make falco-logs                                              
Makefile:39: warning: overriding commands for target `falco-logs'
Makefile:35: warning: ignoring old commands for target `falco-logs'
kubectl logs -n kube-system -l app=falco
Defaulted container "falco" out of: falco, init-pipe (init)
2025-05-17T10:44:28+0000: System info: Linux version 6.13.7-orbstack-00283-g9d1400e7e9c6 (orbstack@builder) (ClangBuiltLinux clang version 19.1.4 (https://github.com/llvm/llvm-project.git aadaa00de76ed0c4987b97450dd638f63a385bed), ClangBuiltLinux LLD 19.1.4 (https://github.com/llvm/llvm-project.git aadaa00de76ed0c4987b97450dd638f63a385bed)) #104 SMP Mon Mar 17 06:15:48 UTC 2025
2025-05-17T10:44:28+0000: Loading rules from:
2025-05-17T10:44:29+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2025-05-17T10:44:29+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2025-05-17T10:44:29+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2025-05-17T10:44:29+0000: Starting health webserver with threadiness 12, listening on 0.0.0.0:8765
2025-05-17T10:44:29+0000: Loaded event sources: syscall
2025-05-17T10:44:29+0000: Enabled event sources: syscall
2025-05-17T10:44:29+0000: Opening 'syscall' source with modern BPF probe.
2025-05-17T10:44:29+0000: One ring buffer every '2' CPUs.
hibana@mac robot_dreams_petclinic % kubectl run shelltest --rm -i --tty --image=alpine -- /bin/sh
If you don't see a command prompt, try pressing enter.
/ # touch /bin/evil_script.sh
/ # chmod +x /bin/evil_script.sh
/ # ^C
Session ended, resume using 'kubectl attach shelltest -c shelltest -i -t' command when the pod is running
pod "shelltest" deleted
hibana@mac robot_dreams_petclinic % kubectl attach shelltest -c shelltest -i -t
Error from server (NotFound): pods "shelltest" not found
hibana@mac robot_dreams_petclinic % make falco-logs
Makefile:39: warning: overriding commands for target `falco-logs'
Makefile:35: warning: ignoring old commands for target `falco-logs'
kubectl logs -n kube-system -l app=falco
Defaulted container "falco" out of: falco, init-pipe (init)
2025-05-17T10:44:29+0000: Opening 'syscall' source with modern BPF probe.
2025-05-17T10:44:29+0000: One ring buffer every '2' CPUs.
2025-05-17T10:44:48.050940957+0000: Critical Fileless execution via memfd_create (container_start_ts=1747476726295519499 proc_cwd= evt_res=SUCCESS proc_sname= gparent=<NA> evt_type=execve user=root user_uid=0 user_loginuid=-1 process=.runc proc_exepath=memfd:runc parent=<NA> command=.runc --version terminal=0 exe_flags=EXE_WRITABLE|EXE_FROM_MEMFD container_id= container_name=<NA>)
2025-05-17T10:45:01.534825266+0000: Critical Executing binary not part of base image (proc_exe=mount proc_sname= gparent=<NA> proc_exe_ino_ctime=1747476829902213664 proc_exe_ino_mtime=5587654956884332544 proc_exe_ino_ctime_duration_proc_start=1871632418560 proc_cwd=./ container_start_ts=1747476829452185700 evt_type=execve user=root user_uid=0 user_loginuid=-1 process=mount proc_exepath=/usr/bin/mount parent=<NA> command=mount -t tmpfs -o size=12591759360,noswap tmpfs /var/lib/kubelet/pods/6866e1b0-ebd6-42ae-9ccc-6a67ce78051e/volumes/kubernetes.io~projected/kube-api-access-7lqbz terminal=0 exe_flags=EXE_WRITABLE|EXE_UPPER_LAYER container_id= container_name=<NA>)
2025-05-17T10:45:03.363883699+0000: Notice A shell was spawned in a container with an attached terminal (evt_type=execve user=root user_uid=0 user_loginuid=-1 process=sh proc_exepath=/bin/busybox parent=containerd-shim command=sh terminal=34816 exe_flags=EXE_WRITABLE|EXE_LOWER_LAYER container_id=54e351f8ca95 container_name=<NA>)
2025-05-17T10:45:08.051421337+0000: Critical Fileless execution via memfd_create (container_start_ts=1747476726295519499 proc_cwd= evt_res=SUCCESS proc_sname= gparent=<NA> evt_type=execve user=root user_uid=0 user_loginuid=-1 process=.runc proc_exepath=memfd:runc parent=<NA> command=.runc --version terminal=0 exe_flags=EXE_WRITABLE|EXE_FROM_MEMFD container_id= container_name=<NA>)
2025-05-17T10:45:22.444933248+0000: Critical Executing binary not part of base image (proc_exe=umount proc_sname= gparent=<NA> proc_exe_ino_ctime=1747476829902213664 proc_exe_ino_mtime=5587654956884332544 proc_exe_ino_ctime_duration_proc_start=1892542572250 proc_cwd=./ container_start_ts=1747476829452185700 evt_type=execve user=root user_uid=0 user_loginuid=-1 process=umount proc_exepath=/usr/bin/umount parent=<NA> command=umount /var/lib/kubelet/pods/6866e1b0-ebd6-42ae-9ccc-6a67ce78051e/volumes/kubernetes.io~projected/kube-api-access-7lqbz terminal=0 exe_flags=EXE_WRITABLE|EXE_UPPER_LAYER container_id= container_name=<NA>)
2025-05-17T10:45:28.052478135+0000: Critical Fileless execution via memfd_create (container_start_ts=1747476726295519499 proc_cwd= evt_res=SUCCESS proc_sname= gparent=<NA> evt_type=execve user=root user_uid=0 user_loginuid=-1 process=.runc proc_exepath=memfd:runc parent=<NA> command=.runc --version terminal=0 exe_flags=EXE_WRITABLE|EXE_FROM_MEMFD container_id= container_name=<NA>)
2025-05-17T10:45:34.833215601+0000: Critical Executing binary not part of base image (proc_exe=mount proc_sname= gparent=<NA> proc_exe_ino_ctime=1747476829902213664 proc_exe_ino_mtime=5587654956884332544 proc_exe_ino_ctime_duration_proc_start=1904930632270 proc_cwd= container_start_ts=1747476829452185700 evt_type=execve user=root user_uid=0 user_loginuid=-1 process=mount proc_exepath=/usr/bin/mount parent=<NA> command=mount -t tmpfs -o size=12591759360,noswap tmpfs /var/lib/kubelet/pods/a2828ee2-2702-4aa9-b6ab-c32a35953d44/volumes/kubernetes.io~projected/kube-api-access-6cqzp terminal=0 exe_flags=EXE_WRITABLE|EXE_UPPER_LAYER container_id= container_name=<NA>)
2025-05-17T10:45:36.592474969+0000: Notice A shell was spawned in a container with an attached terminal (evt_type=execve user=root user_uid=0 user_loginuid=-1 process=sh proc_exepath=/bin/busybox parent=containerd-shim command=sh terminal=34816 exe_flags=EXE_WRITABLE|EXE_LOWER_LAYER container_id=3ab5329f27b1 container_name=<NA>)
```