# HM-32

## Terraform IaC for Ansible config
```textmate
terraform/main.tf
```
```terraform
provider "aws" {
  region = var.instance_region_id
}

resource "aws_vpc" "ansible_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ansible-demo-vpc"
  }
}

resource "aws_key_pair" "europe_stockholm_key" {
  key_name   = "europe-stockholm-ssh-rsa-keygen"
  public_key = file("../ssh-keys/europe-stockholm-ssh-rsa-keygen.pub")
}

resource "aws_internet_gateway" "ansible_gateway" {
  vpc_id = aws_vpc.ansible_vpc.id

  tags = {
    Name = "ansible-gateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ansible_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansible-public-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ansible_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_gateway.id
  }

  tags = {
    Name = "ansible-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "ansible_access" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.ansible_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-access"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ansible_access.id]

  key_name = aws_key_pair.europe_stockholm_key.key_name

  tags = {
    Name        = "ansible-demo"
    Environment = "development"
  }
}
```

```textmate
terraform/outputs.tf
```
```terraform
output "aws_vpc_id" {
  value = aws_vpc.ansible_vpc.id
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}
```

```textmate
terraform/variables.tf
```
```terraform
variable "instance_region_id" {
  default = "eu-north-1"
}
```

```textmate
hibana@mac robot_dreams_petclinic % cd ansible 
hibana@mac ansible % ansible-vault encrypt ansible/group_vars/all/vault.yml
[WARNING]: Error getting vault password file (default): The vault password file /Users/hibana/PhpstormProjects/robot_dreams_petclinic/ansible/vault_pass.txt was not found
ERROR! The vault password file /Users/hibana/PhpstormProjects/robot_dreams_petclinic/ansible/vault_pass.txt was not found
hibana@mac robot_dreams_petclinic % ansible-vault encrypt ansible/group_vars/all/vault.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

hibana@mac ansible % ansible-inventory -i inventory/aws_ec2.yml --graph
@all:
  |--@ungrouped:
  |--@aws_ec2:
hibana@mac ansible % ansible-inventory -i inventory/aws_ec2.yml --list
{
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "children": [
            "ungrouped",
            "aws_ec2"
        ]
    }
}
```

Terraform
```textmate
hibana@mac terraform % terraform validate

Success! The configuration is valid.

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

aws_vpc_id = "vpc-021808d9282513ca0"
web_public_ip = "13.60.181.87"
```

![ec2_instance_create.png](assets/ec2_instance_create.png)

```textmate
hibana@mac ansible % ansible-playbook -i inventory.ini playbooks/playbook.yml --vault-password-file vault-pass.txt

PLAY [Test connection to EC2 instance] *****************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host 13.60.181.87 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [13.60.181.87]

TASK [Ping EC2] ****************************************************************************************************************************************************************
ok: [13.60.181.87]

PLAY RECAP *********************************************************************************************************************************************************************
13.60.181.87               : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

hibana@mac ansible % 
```

## Vo. 1 -> First version of ansible, with single playbook
```textmate
hibana@mac ansible % ANSIBLE_INVENTORY_ENABLED=amazon.aws.aws_ec2 \
ansible-playbook -i inventory/aws_ec2.yml playbooks/setup_firewall.yml \
--vault-password-file vault-pass.txt \
--private-key ssh-keys/europe-stockholm-ssh-rsa-keygen

PLAY [all] *********************************************************************************************************************************************************************
[WARNING]: Found variable using reserved name: tags

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host 13.60.181.87 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is installed] *******************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is started and enabled] *********************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow SSH] ***************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTP] **************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTPS] *************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Reload firewalld to apply rules] *****************************************************************************************************************************
changed: [13.60.181.87]

PLAY RECAP *********************************************************************************************************************************************************************
13.60.181.87               : ok=7    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```textmate
PLAY [all] *********************************************************************************************************************************************************************
[WARNING]: Found variable using reserved name: tags

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host 13.60.181.87 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [13.60.181.87]

TASK [baseline : Add SSH key] **************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [baseline : Install baseline packages (Amazon Linux)] *********************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is installed] *******************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is started and enabled] *********************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow SSH] ***************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTP] **************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTPS] *************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Reload firewalld to apply rules] *****************************************************************************************************************************
changed: [13.60.181.87]

TASK [nginx : Install Nginx] ***************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [nginx : Copy index.html using template] **********************************************************************************************************************************
ok: [13.60.181.87]

TASK [nginx : Ensure Nginx is running and enabled] *****************************************************************************************************************************
ok: [13.60.181.87]

PLAY RECAP *********************************************************************************************************************************************************************
13.60.181.87               : ok=12   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

hibana@mac ansible % curl http://13.60.181.87
<!DOCTYPE html>
<html>
<head>
    <title>Ansible Website</title>
</head>
<body>
    <h1>Welcome to Ansible Website</h1>
</body>
</html>                

[ec2-user@ip-10-0-1-63 ~]$ rpm -q vim-enhanced git mc firewalld
vim-enhanced-9.1.1202-1.amzn2023.0.1.x86_64
git-2.47.1-1.amzn2023.0.3.x86_64
mc-4.8.28-2.amzn2023.0.3.x86_64
firewalld-1.2.3-1.amzn2023.noarch                                                              
```

## Vo. 2 -> Final Version
```textmate
hibana@mac ansible % ansible-playbook playbooks/site.yml

PLAY [all] *********************************************************************************************************************************************************************
[WARNING]: Found variable using reserved name: tags

TASK [Gathering Facts] *********************************************************************************************************************************************************
[WARNING]: Platform linux on host 13.60.181.87 is using the discovered Python interpreter at /usr/bin/python3.9, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [13.60.181.87]

TASK [baseline : Add SSH key] **************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [baseline : Install baseline packages (Amazon Linux)] *********************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is installed] *******************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Ensure firewalld is started and enabled] *********************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow SSH] ***************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTP] **************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Allow HTTPS] *************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [firewalld : Reload firewalld to apply rules] *****************************************************************************************************************************
changed: [13.60.181.87]

TASK [nginx : Install Nginx] ***************************************************************************************************************************************************
ok: [13.60.181.87]

TASK [nginx : Copy index.html using template] **********************************************************************************************************************************
ok: [13.60.181.87]

TASK [nginx : Deploy main nginx.conf] ******************************************************************************************************************************************
changed: [13.60.181.87]

TASK [nginx : Ensure Nginx is running and enabled] *****************************************************************************************************************************
changed: [13.60.181.87]

RUNNING HANDLER [nginx : Reload Nginx] *****************************************************************************************************************************************
changed: [13.60.181.87]

PLAY RECAP *********************************************************************************************************************************************************************
13.60.181.87               : ok=14   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


[ec2-user@ip-10-0-1-63 ~]$ sudo nginx -t
nginx: [warn] could not build optimal types_hash, you should increase either types_hash_max_size: 1024 or types_hash_bucket_size: 64; ignoring types_hash_bucket_size
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

![nginx_static_website.png](assets/nginx_static_website.png)

## Ansible
```textmate
ansible/group_vars/all/main.yml
```
```yml
site_title: "Ansible Website"
welcome_message: "Hello from Amazon Linux"
```

```textmate
ansible/group_vars/all/vault.yml
```
```yml
$ANSIBLE_VAULT;1.1;AES256
62653161633632323531616261386264316266626338316564386361653433313938336665326238
3434616433623862626135333938343833343863623863660a616333343063663164313465306435 ...
```

```textmate
ansible/inventory/aws_ec2.yml
```
```yml
plugin: amazon.aws.aws_ec2
regions:
  - eu-north-1
filters:
  tag:Environment: development
keyed_groups:
  - prefix: tag
    key: tags
hostnames:
  - ip-address
compose:
  ansible_host: public_ip_address
```

```textmate
ansible/playbooks/playbook.yml
```
```textmate
Цей плейбук ніде не використовується і був створений тільки в тестових цілях,
тому що досить довго не вдавалось налаштувати щоб вони спілкувались між собою
```
```textmate
- name: Test connection to EC2 instance
  hosts: web
  tasks:
    - name: Ping EC2
      ansible.builtin.ping:
```

```textmate
ansible/playbooks/setup_firewall.yml
```
```yaml
- hosts: all
  become: true
  roles:
    - firewalld
```

```textmate
ansible/playbooks/setup_nginx.yml
```
```yaml
- name: Setup Nginx web server
  hosts: web
  become: true
  vars_files:
    - ../group_vars/main.yml
  roles:
    - nginx
```

```textmate
ansible/playbooks/setup_baseline.yml
```
```yaml
- name: Baseline configuration for all servers
  hosts: all
  become: true
  roles:
    - baseline
```

```textmate
ansible/playbooks/site.yml
```
```yaml
- hosts: all
  become: yes
  vars_files:
    - ../group_vars/all/vault.yml
    - ../group_vars/all/main.yml
  roles:
    - baseline
    - firewalld
    - nginx
```


```textmate
ansible/roles/baseline/tasks/main.yml
```
```yaml
- name: Add SSH key
  authorized_key:
    user: ec2-user
    state: present
    key: "{{ ssh_public_key }}"

- name: Install baseline packages (Amazon Linux)
  when: ansible_os_family == "RedHat"
  dnf:
    name:
      - vim-enhanced
      - git
      - mc
      - firewalld
    state: present
    update_cache: yes
```

```textmate
ansible/roles/baseline/vars/main.yml
```
```yaml
ssh_public_key: "{{ vault_ssh_public_key }}"
```

```textmate
ansible/roles/firewalld/tasks/main.yml
```
```yaml
- name: Ensure firewalld is installed
  ansible.builtin.dnf:
    name: firewalld
    state: present
    update_cache: yes

- name: Ensure firewalld is started and enabled
  ansible.builtin.service:
    name: firewalld
    state: started
    enabled: true

- name: Allow SSH
  ansible.posix.firewalld:
    service: ssh
    permanent: yes
    state: enabled
    immediate: yes

- name: Allow HTTP
  ansible.posix.firewalld:
    service: http
    permanent: yes
    state: enabled
    immediate: yes

- name: Allow HTTPS
  ansible.posix.firewalld:
    service: https
    permanent: yes
    state: enabled
    immediate: yes

- name: Reload firewalld to apply rules
  ansible.builtin.command: firewall-cmd --reload
```

```textmate
ansible/roles/nginx/handlers/main.yml
```
```yaml
- name: Reload Nginx
  ansible.builtin.service:
    name: nginx
    state: reloaded
```

```textmate
ansible/roles/nginx/tasks/main.yml
```
```yaml
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
    state: present
    update_cache: yes

- name: Copy index.html using template
  ansible.builtin.template:
    src: index.html.j2
    dest: /usr/share/nginx/html/index.html
    mode: '0644'

- name: Deploy main nginx.conf
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
  notify: Reload Nginx

- name: Ensure Nginx is running and enabled
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

```textmate
ansible/roles/nginx/templates/index.html.j2
```
```html
<html>
  <head><title>{{ site_title }}</title></head>
  <body>
    <h1>{{ welcome_message }}</h1>
  </body>
</html>

```

```textmate
ansible/roles/nginx/templates/nginx.conf.j2
```

```textmate
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

```textmate
ansible/ansible.cfg
```
```textmate
[defaults]
inventory = inventory/aws_ec2.yml
private_key_file = ssh-keys/europe-stockholm-ssh-rsa-keygen.pem
host_key_checking = False
remote_user = ec2-user
roles_path = ./roles
vault_password_file = vault-pass.txt
interpreter_python = auto
enable_plugins = amazon.aws.aws_ec2
```

```textmate
ansible/inventory.ini
```
```ini
[web]
13.60.181.87 ansible_user=ec2-user ansible_ssh_private_key_file=ssh-keys/europe-stockholm-ssh-rsa-keygen
```

```textmate
ansible/vault-pass.txt
```
```textmate
SOME SUPER SECRET VALUE KEY
```


```textmate
Clean-up

Destroy complete! Resources: 8 destroyed.
```