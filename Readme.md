# HM-35 -> Monitoring


```textmate
hibana@mac robot_dreams_petclinic % ansible-playbook -i ansible/inventory.ini ansible/playbooks/monitoring.yml --private-key rsa-keygen-north.pem


PLAY [Setup monitoring server (Prometheus, Grafana, Loki)] *********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host monitoring-server is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [monitoring-server]

TASK [docker : Install Docker packages] ****************************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Enable and start Docker] ****************************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Add user to docker group] ***************************************************************************************************************************************
changed: [monitoring-server]

PLAY RECAP *********************************************************************************************************************************************************************
monitoring-server          : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```textmate
hibana@mac robot_dreams_petclinic % ssh -i rsa-keygen-north.pem ec2-user@51.20.190.183
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
Last login: Sat Jul 12 10:19:00 2025 from 83.31.118.116
[ec2-user@ip-10-0-1-98 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[ec2-user@ip-10-0-1-98 ~]$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: disabled)
     Active: active (running) since Sat 2025-07-12 10:18:59 UTC; 1min 4s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
    Process: 30130 ExecStartPre=/bin/mkdir -p /run/docker (code=exited, status=0/SUCCESS)
    Process: 30131 ExecStartPre=/usr/libexec/docker/docker-setup-runtimes.sh (code=exited, status=0/SUCCESS)
   Main PID: 30132 (dockerd)
      Tasks: 8
     Memory: 30.3M
        CPU: 348ms
     CGroup: /system.slice/docker.service
             └─30132 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --default-ulimit nofile=32768:65536

Jul 12 10:18:58 ip-10-0-1-98.eu-north-1.compute.internal systemd[1]: Starting docker.service - Docker Application Container Engine...
Jul 12 10:18:58 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:58.922963413Z" level=info msg="Starting up"
Jul 12 10:18:58 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:58.974441273Z" level=info msg="Loading containers: start."
Jul 12 10:18:59 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:59.455793995Z" level=info msg="Loading containers: done."
Jul 12 10:18:59 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:59.478934838Z" level=info msg="Docker daemon" commit=71907ca containerd-snapsho>
Jul 12 10:18:59 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:59.479195569Z" level=info msg="Daemon has completed initialization"
Jul 12 10:18:59 ip-10-0-1-98.eu-north-1.compute.internal dockerd[30132]: time="2025-07-12T10:18:59.527974552Z" level=info msg="API listen on /run/docker.sock"
Jul 12 10:18:59 ip-10-0-1-98.eu-north-1.compute.internal systemd[1]: Started docker.service - Docker Application Container Engine.


hibana@mac robot_dreams_petclinic % ansible-playbook -i ansible/inventory.ini ansible/playbooks/monitoring.yml --private-key rsa-keygen-north.pem

PLAY [Setup monitoring server (Prometheus, Grafana, Loki)] *********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host monitoring-server is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [monitoring-server]

TASK [docker : Install Docker packages] ****************************************************************************************************************************************
ok: [monitoring-server]

TASK [docker : Enable and start Docker] ****************************************************************************************************************************************
ok: [monitoring-server]

TASK [docker : Add user to docker group] ***************************************************************************************************************************************
ok: [monitoring-server]

PLAY RECAP *********************************************************************************************************************************************************************
monitoring-server          : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## After additionals compose installation:
```textmate
hibana@mac robot_dreams_petclinic % ansible-playbook -i ansible/inventory.ini ansible/playbooks/monitoring.yml --private-key rsa-keygen-north.pem

PLAY [Setup monitoring server (Prometheus, Grafana, Loki)] *********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host monitoring-server is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [monitoring-server]

TASK [docker : Install Docker packages] ****************************************************************************************************************************************
ok: [monitoring-server]

TASK [docker : Ensure Docker CLI plugin directory exists] **********************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Download Docker Compose v2 binary] ******************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Enable and start Docker] ****************************************************************************************************************************************
ok: [monitoring-server]

TASK [docker : Add user to docker group] ***************************************************************************************************************************************
ok: [monitoring-server]

PLAY RECAP *********************************************************************************************************************************************************************
monitoring-server          : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


hibana@mac robot_dreams_petclinic % scp -i rsa-keygen-north.pem -r monitoring/ ec2-user@51.20.190.183:/home/ec2-user/
loki-config.yml                                                                                                                               100%  649    22.6KB/s   00:00    
promtail-config.yml                                                                                                                           100%  825    26.9KB/s   00:00    
prometheus.yml                                                                                                                                100%  221     7.7KB/s   00:00    
docker-compose.yml                                                                                                                            100%  925    31.5KB/s   00:00    

[ec2-user@ip-10-0-1-98 monitoring]$ sudo docker compose up -d
[+] Running 46/4
 ✔ grafana Pulled                                                                                                                                                         18.2s 
 ✔ loki Pulled                                                                                                                                                            10.4s 
 ✔ promtail Pulled                                                                                                                                                        16.0s 
 ✔ prometheus Pulled                                                                                                                                                      15.9s 
[+] Running 5/5
 ✔ Network monitoring_default  Created                                                                                                                                     0.2s 
 ✔ Container promtail          Started                                                                                                                                     0.9s 
 ✔ Container grafana           Started                                                                                                                                     1.2s 
 ✔ Container prometheus        Started                                                                                                                                     1.1s 
 ✔ Container loki              Started                                                                                                                                     1.2s 
```


```
hibana@mac robot_dreams_petclinic % ansible-playbook -i ansible/inventory.ini ansible/playbooks/webserver.yml --private-key rsa-keygen-north.pem

PLAY [Deploy Promtail and Node Exporter on web server] *************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host web-server is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [web-server]

TASK [nginx : Install Nginx] ***************************************************************************************************************************************************
ok: [web-server]

TASK [nginx : Enable and start Nginx] ******************************************************************************************************************************************
ok: [web-server]

TASK [mysql : Ensure pip3 is installed] ****************************************************************************************************************************************
ok: [web-server]

TASK [mysql : Install PyMySQL for Ansible MySQL modules] ***********************************************************************************************************************
ok: [web-server]

TASK [mysql : Create database user] ********************************************************************************************************************************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false, so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [web-server]

TASK [node_exporter : Install dependencies] ************************************************************************************************************************************
ok: [web-server]

TASK [node_exporter : Download Node Exporter] **********************************************************************************************************************************
changed: [web-server]

TASK [node_exporter : Extract Node Exporter] ***********************************************************************************************************************************
changed: [web-server]

TASK [node_exporter : Create Node Exporter service] ****************************************************************************************************************************
changed: [web-server]

TASK [node_exporter : Enable and start Node Exporter] **************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Ensure monitoring directory exists] *********************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Copy Docker Compose file] *******************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Ensure config directory exists] *************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Copy Promtail config] ***********************************************************************************************************************************
changed: [web-server]

PLAY RECAP *********************************************************************************************************************************************************************
web-server                 : ok=15   changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```