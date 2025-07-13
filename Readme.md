# HM-35 -> Monitoring


### Run Monitoring Playbook
```textmate
hibana@mac robot_dreams_petclinic % ansible-playbook -i ansible/inventory.ini ansible/playbooks/monitoring.yml --private-key rsa-keygen-north.pem

PLAY [Setup monitoring server (Prometheus, Grafana, Loki)] *********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host monitoring-server is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter
could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [monitoring-server]

TASK [docker : Ensure monitoring and config directories exist] *****************************************************************************************************************
ok: [monitoring-server] => (item=/opt/monitoring)
ok: [monitoring-server] => (item=/opt/monitoring/configs)

TASK [docker : Upload docker-compose.yml] **************************************************************************************************************************************
ok: [monitoring-server]

TASK [docker : Upload Prometheus config] ***************************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Upload Loki config] *********************************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Upload Promtail config] *****************************************************************************************************************************************
changed: [monitoring-server]

TASK [docker : Start monitoring stack with Docker Compose] *********************************************************************************************************************
changed: [monitoring-server]

PLAY RECAP *********************************************************************************************************************************************************************
monitoring-server          : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

hibana@mac robot_dreams_petclinic % ssh -i rsa-keygen-north.pem ec2-user@16.16.58.120                                                            
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
Last login: Sun Jul 13 06:15:01 2025 from 83.31.118.116
[ec2-user@ip-10-0-1-252 ~]$ docker ps
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                                       NAMES
816c70958577   grafana/promtail:latest   "/usr/bin/promtail -…"   10 seconds ago   Up 8 seconds                                                promtail
987b7422f405   grafana/loki:latest       "/usr/bin/loki -conf…"   10 seconds ago   Up 8 seconds    0.0.0.0:3100->3100/tcp, :::3100->3100/tcp   loki
e617fc21c5bb   prom/prometheus           "/bin/prometheus --c…"   10 seconds ago   Up 8 seconds    0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus
b03e1284c730   grafana/grafana           "/run.sh"                16 minutes ago   Up 16 minutes   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   grafana
```

## Run WebServer Playbook
```textmate
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
ok: [web-server]

TASK [node_exporter : Extract Node Exporter] ***********************************************************************************************************************************
ok: [web-server]

TASK [node_exporter : Create Node Exporter service] ****************************************************************************************************************************
ok: [web-server]

TASK [node_exporter : Enable and start Node Exporter] **************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Install Docker] *****************************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Enable and start Docker] ********************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Add ec2-user to docker group] ***************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Create Docker CLI plugins directory] ********************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Download docker-compose V2 binary] **********************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Enable and start Docker service] ************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Add ec2-user to docker group] ***************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure /opt/monitoring and subdirectories exist] ********************************************************************************************************
ok: [web-server] => (item=/opt/monitoring)
ok: [web-server] => (item=/opt/monitoring/configs)

TASK [web_monitoring : Copy docker-compose.yml] ********************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure promtail-config.yml is not a directory] **********************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Copy promtail config] ***********************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Start monitoring services via docker-compose] ***********************************************************************************************************
changed: [web-server]

PLAY RECAP *********************************************************************************************************************************************************************
web-server                 : ok=23   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[ec2-user@ip-10-0-1-140 ~]$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED         STATUS              PORTS     NAMES
c9f5eada2b83   prom/node-exporter:latest   "/bin/node_exporter"     5 minutes ago   Up About a minute             node-exporter
66813e942ade   grafana/promtail:latest     "/usr/bin/promtail -…"   5 minutes ago   Up 5 minutes                  promtail
```


```textmate
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
ok: [web-server]

TASK [node_exporter : Extract Node Exporter] ***********************************************************************************************************************************
ok: [web-server]

TASK [node_exporter : Create Node Exporter service] ****************************************************************************************************************************
ok: [web-server]

TASK [node_exporter : Enable and start Node Exporter] **************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Install Docker] *****************************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Enable and start Docker] ********************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Add ec2-user to docker group] ***************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure MySQL log directory exists] **********************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure MySQL log files exist] ***************************************************************************************************************************
changed: [web-server] => (item=/var/log/mysql/error.log)
changed: [web-server] => (item=/var/log/mysql/slow.log)

TASK [web_monitoring : Create Docker CLI plugins directory] ********************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Download docker-compose V2 binary] **********************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Enable and start Docker service] ************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Add ec2-user to docker group] ***************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure /opt/monitoring and subdirectories exist] ********************************************************************************************************
ok: [web-server] => (item=/opt/monitoring)
ok: [web-server] => (item=/opt/monitoring/configs)

TASK [web_monitoring : Copy docker-compose.yml] ********************************************************************************************************************************
ok: [web-server]

TASK [web_monitoring : Ensure promtail-config.yml is not a directory] **********************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Copy promtail config] ***********************************************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Remove existing promtail container if present] **********************************************************************************************************
changed: [web-server]

TASK [web_monitoring : Start monitoring services via docker-compose] ***********************************************************************************************************
changed: [web-server]

PLAY RECAP *********************************************************************************************************************************************************************
web-server                 : ok=26   changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```