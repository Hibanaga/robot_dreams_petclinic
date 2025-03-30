# HM 6 -> Advanced Linux

# Завдання

1. Встановити й налаштувати вебсервер Nginx через офіційний репозиторій. Додати й видалити PPA-репозиторій для Nginx, а потім повернутися до офіційної версії пакета за допомогою ppa-purge.

* Vagrant:
```
  config.vm.provision "setup_nginx", type: "shell", inline: <<-SHELL
    echo "Running apt update..."
    apt-get -y update
    echo "Installing software-properties-common..."
    apt-get -y install software-properties-common

    echo "Installing Nginx from official Ubuntu repo..."
    apt-get -y install nginx
    echo "Initial Nginx version:"
    nginx -v

    echo "Adding PPA: ondrej/nginx"
    add-apt-repository -y ppa:ondrej/nginx
    echo "Installing PPA-purge..."
    apt-get -y install ppa-purge

    echo "Reverting to default Nginx using PPA-purge..."
    ppa-purge -y ppa:ondrej/nginx
    echo "Final Nginx version:"
    nginx -v
    echo "✅ Nginx installation and cleanup complete."
  SHELL
```

* Logs

```
==> default: Running provisioner: setup_nginx (shell)...
    default: Running: inline script
    default: Running apt update...
    default: Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease [126 kB]
    default: Get:3 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease [126 kB]
    default: Get:4 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease [126 kB]
    default: Get:5 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 Packages [962 kB]
    default: Get:6 http://ports.ubuntu.com/ubuntu-ports noble-updates/main Translation-en [213 kB]
    default: Get:7 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 Components [148 kB]
    default: Get:8 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted arm64 Packages [989 kB]
    default: Get:9 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted Translation-en [170 kB]
    default: Get:10 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted arm64 Components [212 B]
    default: Get:11 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 Packages [1,016 kB]
    default: Get:12 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe Translation-en [263 kB]
    default: Get:13 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 Components [364 kB]
    default: Get:14 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse arm64 Packages [16.9 kB]
    default: Get:15 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse Translation-en [4,788 B]
    default: Get:16 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse arm64 Components [212 B]
    default: Get:17 http://ports.ubuntu.com/ubuntu-ports noble-backports/main arm64 Packages [39.1 kB]
    default: Get:18 http://ports.ubuntu.com/ubuntu-ports noble-backports/main Translation-en [8,676 B]
    default: Get:19 http://ports.ubuntu.com/ubuntu-ports noble-backports/main arm64 Components [3,580 B]
    default: Get:20 http://ports.ubuntu.com/ubuntu-ports noble-backports/restricted arm64 Components [216 B]
    default: Get:21 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe arm64 Packages [26.5 kB]
    default: Get:22 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe Translation-en [16.3 kB]
    default: Get:23 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe arm64 Components [15.8 kB]
    default: Get:24 http://ports.ubuntu.com/ubuntu-ports noble-backports/multiverse arm64 Components [212 B]
    default: Get:25 http://ports.ubuntu.com/ubuntu-ports noble-security/main arm64 Packages [715 kB]
    default: Get:26 http://ports.ubuntu.com/ubuntu-ports noble-security/main Translation-en [136 kB]
    default: Get:27 http://ports.ubuntu.com/ubuntu-ports noble-security/main arm64 Components [5,688 B]
    default: Get:28 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted arm64 Packages [950 kB]
    default: Get:29 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted Translation-en [164 kB]
    default: Get:30 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted arm64 Components [212 B]
    default: Get:31 http://ports.ubuntu.com/ubuntu-ports noble-security/universe arm64 Packages [797 kB]
    default: Get:32 http://ports.ubuntu.com/ubuntu-ports noble-security/universe Translation-en [177 kB]
    default: Get:33 http://ports.ubuntu.com/ubuntu-ports noble-security/universe arm64 Components [52.0 kB]
    default: Get:34 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse arm64 Packages [15.3 kB]
    default: Get:35 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse Translation-en [3,792 B]
    default: Get:36 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse arm64 Components [212 B]
    default: Fetched 7,653 kB in 2s (4,420 kB/s)
    default: Reading package lists...
    default: Installing software-properties-common...
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: software-properties-common is already the newest version (0.99.49.1).
    default: 0 upgraded, 0 newly installed, 0 to remove and 76 not upgraded.
    default: Installing Nginx from official Ubuntu repo...
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: The following additional packages will be installed:
    default:   nginx-common
    default: Suggested packages:
    default:   fcgiwrap nginx-doc ssl-cert
    default: The following NEW packages will be installed:
    default:   nginx nginx-common
    default: 0 upgraded, 2 newly installed, 0 to remove and 76 not upgraded.
    default: Need to get 549 kB of archives.
    default: After this operation, 1,621 kB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 nginx-common all 1.24.0-2ubuntu7.1 [31.2 kB]
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 nginx arm64 1.24.0-2ubuntu7.1 [517 kB]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 549 kB in 0s (1,539 kB/s)
    default: Selecting previously unselected package nginx-common.
(Reading database ... 52381 files and directories currently installed.)
    default: Preparing to unpack .../nginx-common_1.24.0-2ubuntu7.1_all.deb ...
    default: Unpacking nginx-common (1.24.0-2ubuntu7.1) ...
    default: Selecting previously unselected package nginx.
    default: Preparing to unpack .../nginx_1.24.0-2ubuntu7.1_arm64.deb ...
    default: Unpacking nginx (1.24.0-2ubuntu7.1) ...
    default: Setting up nginx (1.24.0-2ubuntu7.1) ...
    default: Setting up nginx-common (1.24.0-2ubuntu7.1) ...
    default: Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    default: Processing triggers for ufw (0.36.2-6) ...
    default: Processing triggers for man-db (2.12.0-4build2) ...
    default: 
    default: Running kernel seems to be up-to-date.
    default: 
    default: No services need to be restarted.
    default: 
    default: No containers need to be restarted.
    default: 
    default: No user sessions are running outdated binaries.
    default: 
    default: No VM guests are running outdated hypervisor (qemu) binaries on this host.
    default: Initial Nginx version:
    default: nginx version: nginx/1.24.0 (Ubuntu)
    default: Adding PPA: ondrej/nginx
    default: Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
    default: Hit:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease
    default: Hit:3 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease
    default: Hit:4 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease
    default: Get:5 https://ppa.launchpadcontent.net/ondrej/nginx/ubuntu noble InRelease [24.4 kB]
    default: Get:6 https://ppa.launchpadcontent.net/ondrej/nginx/ubuntu noble/main arm64 Packages [7,472 B]
    default: Get:7 https://ppa.launchpadcontent.net/ondrej/nginx/ubuntu noble/main Translation-en [7,072 B]
    default: Fetched 38.9 kB in 0s (93.7 kB/s)
    default: Reading package lists...
    default: PPA publishes dbgsym, you may need to include 'main/debug' component
    default: Repository: 'Types: deb
    default: URIs: https://ppa.launchpadcontent.net/ondrej/nginx/ubuntu/
    default: Suites: noble
    default: Components: main
    default: '
    default: Description:
    default: This branch follows latest NGINX Stable packages compiled against latest OpenSSL for HTTP/2 and TLS 1.3 support.
    default: 
    default: BUGS&FEATURES: This PPA now has a issue tracker: https://deb.sury.org/#bug-reporting
    default: 
    default: PLEASE READ: If you like my work and want to give me a little motivation, please consider donating: https://donate.sury.org
    default: More info: https://launchpad.net/~ondrej/+archive/ubuntu/nginx
    default: Adding repository.
    default: Installing PPA-purge...
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: Suggested packages:
    default:   aptitude
    default: The following NEW packages will be installed:
    default:   ppa-purge
    default: 0 upgraded, 1 newly installed, 0 to remove and 78 not upgraded.
    default: Need to get 5,996 B of archives.
    default: After this operation, 23.6 kB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 ppa-purge all 0.2.8+bzr63-0ubuntu2.1 [5,996 B]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 5,996 B in 0s (64.6 kB/s)
    default: Selecting previously unselected package ppa-purge.
(Reading database ... 52429 files and directories currently installed.)
    default: Preparing to unpack .../ppa-purge_0.2.8+bzr63-0ubuntu2.1_all.deb ...
    default: Unpacking ppa-purge (0.2.8+bzr63-0ubuntu2.1) ...
    default: Setting up ppa-purge (0.2.8+bzr63-0ubuntu2.1) ...
    default: Processing triggers for man-db (2.12.0-4build2) ...
    default: 
    default: Running kernel seems to be up-to-date.
    default: 
    default: No services need to be restarted.
    default: 
    default: No containers need to be restarted.
    default: 
    default: No user sessions are running outdated binaries.
    default: 
    default: No VM guests are running outdated hypervisor (qemu) binaries on this host.
    default: Reverting to default Nginx using PPA-purge...
    default: Updating packages lists
    default: PPA to be removed: ondrej nginx
    default: Package revert list generated:
    default:  nginx/noble nginx-common/noble
    default: 
    default: Updating packages lists
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: nginx is already the newest version (1.24.0-2ubuntu7.1).
    default: nginx-common is already the newest version (1.24.0-2ubuntu7.1).
    default: nginx-common set to manually installed.
    default: 0 upgraded, 0 newly installed, 0 to remove and 76 not upgraded.
    default: W: --force-yes is deprecated, use one of the options starting with --allow instead.
    default: PPA purged successfully
    default: Final Nginx version:
    default: nginx version: nginx/1.24.0 (Ubuntu)
    default: ✅ Nginx installation and cleanup complete.
```


2. Написати й налаштувати власний systemd-сервіс для запуску простого скрипта (наприклад, скрипт, який пише поточну дату і час у файл щохвилини).

* Vagrant
```
  config.vm.provision "time-logger", type: "shell", inline: <<-SHELL
    echo "Setting up log-time.sh systemd timer..."

    cp /vagrant/systemd/log-time.sh /usr/local/bin/log-time.sh
    chmod +x /usr/local/bin/log-time.sh

    touch /mnt/data/output.txt

    cp /vagrant/systemd/log-time.service /etc/systemd/system/log-time.service
    cp /vagrant/systemd/log-time.timer /etc/systemd/system/log-time.timer

    systemctl daemon-reexec
    systemctl daemon-reload
    systemctl enable --now log-time.timer

    echo "✅ log-time.timer enabled and running."
  SHELL
```

* systemd/log-time.sh
```
#!/bin/bash

echo "$(date '+%Y-%m-%d %H:%M:%S')" >> /mnt/data/output.txt
```

* systemd/log-time.service
```
[Unit]
Description=Log current time to /mnt/data/output.txt

[Service]
Type=oneshot
ExecStart=/usr/local/bin/log-time.sh
```

* systemd/log-time.timer
```
[Unit]
Description=Run log-time.sh every minute

[Timer]
OnCalendar=*-*-* *:*:00
AccuracySec=1s
Persistent=true

[Install]
WantedBy=timers.target
```

* Logs
```
==> default: Running provisioner: time-logger (shell)...
    default: Running: inline script
    default: Setting up log-time.sh systemd timer...
    default: Created symlink /etc/systemd/system/timers.target.wants/log-time.timer → /etc/systemd/system/log-time.timer.
    default: ✅ log-time.timer enabled and running.


vagrant@vagrant:~$ cd /mnt/data
vagrant@vagrant:/mnt/data$ ls -a
.  ..  lost+found  output.txt
vagrant@vagrant:/mnt/data$ cat output.txt 
2025-03-30 13:50:00
2025-03-30 13:51:00
2025-03-30 13:52:00
2025-03-30 13:53:00
2025-03-30 13:54:00
2025-03-30 13:55:00
2025-03-30 13:56:00

vagrant@vagrant:/mnt/data$ ps aux | grep log-time.sh
vagrant     4838  0.0  0.2   6680  1920 pts/0    S+   13:58   0:00 grep --color=auto log-time.sh
vagrant@vagrant:/mnt/data$ journalctl -u log-time.service -f
Mar 30 13:55:00 vagrant systemd[1]: Finished log-time.service - Log current time to /mnt/data/output.txt.
Mar 30 13:56:00 vagrant systemd[1]: Starting log-time.service - Log current time to /mnt/data/output.txt...
Mar 30 13:56:00 vagrant systemd[1]: log-time.service: Deactivated successfully.
Mar 30 13:56:00 vagrant systemd[1]: Finished log-time.service - Log current time to /mnt/data/output.txt.
Mar 30 13:57:00 vagrant systemd[1]: Starting log-time.service - Log current time to /mnt/data/output.txt...
Mar 30 13:57:00 vagrant systemd[1]: log-time.service: Deactivated successfully.
Mar 30 13:57:00 vagrant systemd[1]: Finished log-time.service - Log current time to /mnt/data/output.txt.
Mar 30 13:58:00 vagrant systemd[1]: Starting log-time.service - Log current time to /mnt/data/output.txt...
Mar 30 13:58:00 vagrant systemd[1]: log-time.service: Deactivated successfully.
Mar 30 13:58:00 vagrant systemd[1]: Finished log-time.service - Log current time to /mnt/data/output.txt.

vagrant@vagrant:/mnt/data$ ps aux | grep log-time
vagrant     4859  0.0  0.2   6676  1920 pts/0    S+   14:00   0:00 grep --color=auto log-time
```

3. Налаштувати брандмауер за допомогою UFW або iptables. Заборонити доступ до порту 22 (SSH) з певного IP, але дозволити з іншого IP. Налаштувати Fail2Ban для захисту від підбору паролів через SSH.

* Vagrant
```
  config.vm.provision "configure_firewall", type: "shell", inline: <<-SHELL
    echo "Installing and configuring UFW and Fail2Ban..."

    apt-get update -y
    apt-get install -y ufw fail2ban

    ufw allow in on eth0 to any port 22 proto tcp
    ufw allow from 192.168.1.10 to any port 22 proto tcp
    ufw deny from 192.168.1.11 to any port 22 proto tcp

    ufw --force enable
    ufw status numbered

    cat <<EOF > /etc/fail2ban/jail.d/ssh.local
[sshd]
enabled = true
maxretry = 3
findtime = 1d
bantime = 1w
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

    systemctl restart fail2ban
    systemctl enable fail2ban

    echo "✅ Fail2Ban status:"
    fail2ban-client status sshd

    echo "Pinging Fail2Ban..."
    fail2ban-client ping

    echo "Manually banning test IPs..."
    fail2ban-client set sshd banip 192.168.1.11
    fail2ban-client set sshd banip 192.168.1.12
    fail2ban-client set sshd banip 192.168.1.13

    echo "✅ Final Fail2Ban status:"
    fail2ban-client status sshd
  SHELL
```

* Logs
```
==> default: Running provisioner: configure_firewall (shell)...
    default: Running: inline script
    default: Installing and configuring UFW and Fail2Ban...
    default: Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
    default: Hit:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease
    default: Hit:3 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease
    default: Hit:4 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease
    default: Reading package lists...
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: ufw is already the newest version (0.36.2-6).
    default: The following additional packages will be installed:
    default:   python3-pyasyncore python3-pyinotify whois
    default: Suggested packages:
    default:   mailx monit sqlite3 python-pyinotify-doc
    default: The following NEW packages will be installed:
    default:   fail2ban python3-pyasyncore python3-pyinotify whois
    default: 0 upgraded, 4 newly installed, 0 to remove and 76 not upgraded.
    default: Need to get 494 kB of archives.
    default: After this operation, 2,654 kB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 python3-pyasyncore all 1.0.2-2 [10.1 kB]
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 fail2ban all 1.0.2-3ubuntu0.1 [409 kB]
    default: Get:3 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 python3-pyinotify all 0.9.6-2ubuntu1 [25.0 kB]
    default: Get:4 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 whois arm64 5.5.22 [50.3 kB]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 494 kB in 0s (1,543 kB/s)
    default: Selecting previously unselected package python3-pyasyncore.
(Reading database ... 52435 files and directories currently installed.)
    default: Preparing to unpack .../python3-pyasyncore_1.0.2-2_all.deb ...
    default: Unpacking python3-pyasyncore (1.0.2-2) ...
    default: Selecting previously unselected package fail2ban.
    default: Preparing to unpack .../fail2ban_1.0.2-3ubuntu0.1_all.deb ...
    default: Unpacking fail2ban (1.0.2-3ubuntu0.1) ...
    default: Selecting previously unselected package python3-pyinotify.
    default: Preparing to unpack .../python3-pyinotify_0.9.6-2ubuntu1_all.deb ...
    default: Unpacking python3-pyinotify (0.9.6-2ubuntu1) ...
    default: Selecting previously unselected package whois.
    default: Preparing to unpack .../whois_5.5.22_arm64.deb ...
    default: Unpacking whois (5.5.22) ...
    default: Setting up whois (5.5.22) ...
    default: Setting up python3-pyasyncore (1.0.2-2) ...
    default: Setting up fail2ban (1.0.2-3ubuntu0.1) ...
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:224: SyntaxWarning: invalid escape sequence '\s'
    default:   "1490349000 test failed.dns.ch", "^\s*test <F-ID>\S+</F-ID>"
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:435: SyntaxWarning: invalid escape sequence '\S'
    default:   '^'+prefix+'<F-ID>User <F-USER>\S+</F-USER></F-ID> not allowed\n'
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:443: SyntaxWarning: invalid escape sequence '\S'
    default:   '^'+prefix+'User <F-USER>\S+</F-USER> not allowed\n'
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:444: SyntaxWarning: invalid escape sequence '\d'
    default:   '^'+prefix+'Received disconnect from <F-ID><ADDR> port \d+</F-ID>'
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:451: SyntaxWarning: invalid escape sequence '\s'
    default:   _test_variants('common', prefix="\s*\S+ sshd\[<F-MLFID>\d+</F-MLFID>\]:\s+")
    default: /usr/lib/python3/dist-packages/fail2ban/tests/fail2banregextestcase.py:537: SyntaxWarning: invalid escape sequence '\['
    default:   'common[prefregex="^svc\[<F-MLFID>\d+</F-MLFID>\] connect <F-CONTENT>.+</F-CONTENT>$"'
    default: /usr/lib/python3/dist-packages/fail2ban/tests/servertestcase.py:1375: SyntaxWarning: invalid escape sequence '\s'
    default:   "`{ nft -a list chain inet f2b-table f2b-chain | grep -oP '@addr-set-j-w-nft-mp\s+.*\s+\Khandle\s+(\d+)$'; } | while read -r hdl; do`",
    default: /usr/lib/python3/dist-packages/fail2ban/tests/servertestcase.py:1378: SyntaxWarning: invalid escape sequence '\s'
    default:   "`{ nft -a list chain inet f2b-table f2b-chain | grep -oP '@addr6-set-j-w-nft-mp\s+.*\s+\Khandle\s+(\d+)$'; } | while read -r hdl; do`",
    default: /usr/lib/python3/dist-packages/fail2ban/tests/servertestcase.py:1421: SyntaxWarning: invalid escape sequence '\s'
    default:   "`{ nft -a list chain inet f2b-table f2b-chain | grep -oP '@addr-set-j-w-nft-ap\s+.*\s+\Khandle\s+(\d+)$'; } | while read -r hdl; do`",
    default: /usr/lib/python3/dist-packages/fail2ban/tests/servertestcase.py:1424: SyntaxWarning: invalid escape sequence '\s'
    default:   "`{ nft -a list chain inet f2b-table f2b-chain | grep -oP '@addr6-set-j-w-nft-ap\s+.*\s+\Khandle\s+(\d+)$'; } | while read -r hdl; do`",
    default: Created symlink /etc/systemd/system/multi-user.target.wants/fail2ban.service → /usr/lib/systemd/system/fail2ban.service.
    default: Setting up python3-pyinotify (0.9.6-2ubuntu1) ...
    default: Processing triggers for man-db (2.12.0-4build2) ...
    default: 
    default: Running kernel seems to be up-to-date.
    default: 
    default: No services need to be restarted.
    default: 
    default: No containers need to be restarted.
    default: 
    default: No user sessions are running outdated binaries.
    default: 
    default: No VM guests are running outdated hypervisor (qemu) binaries on this host.
    default: Rules updated
    default: Rules updated (v6)
    default: Rules updated
    default: Rules updated
    default: Firewall is active and enabled on system startup
    default: Status: active
    default: 
    default:      To                         Action      From
    default:      --                         ------      ----
    default: [ 1] 22/tcp on eth0             ALLOW IN    Anywhere
    default: [ 2] 22/tcp                     ALLOW IN    192.168.1.10
    default: [ 3] 22/tcp                     DENY IN     192.168.1.11
    default: [ 4] 22/tcp (v6) on eth0        ALLOW IN    Anywhere (v6)
    default: 
    default: Synchronizing state of fail2ban.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
    default: Executing: /usr/lib/systemd/systemd-sysv-install enable fail2ban
    default: ✅ Fail2Ban status:
    default: Status for the jail: sshd
    default: |- Filter
    default: |  |- Currently failed:    0
    default: |  |- Total failed:        0
    default: |  `- Journal matches:     _SYSTEMD_UNIT=sshd.service + _COMM=sshd
    default: `- Actions
    default:    |- Currently banned:    0
    default:    |- Total banned:        0
    default:    `- Banned IP list:
    default: Pinging Fail2Ban...
    default: Server replied: pong
    default: Manually banning test IPs...
    default: 1
    default: 1
    default: 1
    default: ✅ Final Fail2Ban status:
    default: Status for the jail: sshd
    default: |- Filter
    default: |  |- Currently failed:    0
    default: |  |- Total failed:        0
    default: |  `- Journal matches:     _SYSTEMD_UNIT=sshd.service + _COMM=sshd
    default: `- Actions
    default:    |- Currently banned:    3
    default:    |- Total banned:        3
    default:    `- Banned IP list:      192.168.1.11 192.168.1.12 192.168.1.13
```

4. Створити й змонтувати новий розділ на диску, налаштувати його для автоматичного монтування під час завантаження системи.

* Vagrant
```
config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024

    disk_name = "extra_disk.vdi"
    disk_path = File.join(File.expand_path("."), disk_name)
    disk_size = 1024 # in MB

    unless File.exist?(disk_path)
      vb.customize [
        "createhd",
        "--filename", disk_path,
        "--size", disk_size,
        "--variant", "Fixed"
      ]
    end

    vb.customize [
      "storagectl", :id,
      "--name", "SATA",
      "--add", "sata",
      "--controller", "IntelAHCI"
    ]

    vb.customize [
      "storageattach", :id,
      "--storagectl", "SATA",
      "--port", 1,
      "--device", 0,
      "--type", "hdd",
      "--medium", disk_path
    ]
end

  config.vm.provision "setup_disk", type: "shell", inline: <<-SHELL
    apt-get update -y
    apt-get install -y parted

    parted /dev/sdb --script mklabel gpt
    parted /dev/sdb --script mkpart primary ext4 0% 100%
    mkfs.ext4 /dev/sdb1

    mkdir -p /mnt/data
    mount /dev/sdb1 /mnt/data
    echo "/dev/sdb1 /mnt/data ext4 defaults 0 0" >> /etc/fstab

    chown vagrant:vagrant /mnt/data
  SHELL
```

* Logs
```
==> default: Running provisioner: setup_disk (shell)...
    default: Running: inline script
    default: Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
    default: Hit:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease
    default: Hit:3 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease
    default: Hit:4 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease
    default: Reading package lists...
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: parted is already the newest version (3.6-4build1).
    default: 0 upgraded, 0 newly installed, 0 to remove and 76 not upgraded.
    default: mke2fs 1.47.0 (5-Feb-2023)
    default: Creating filesystem with 261632 4k blocks and 65408 inodes
    default: Filesystem UUID: 5a15a2ad-423a-4e02-8717-b35b6038bd7d
    default: Superblock backups stored on blocks:
    default:    32768, 98304, 163840, 229376
    default: 
    default: Allocating group tables: done
    default: Writing inode tables: done
    default: Creating journal (4096 blocks): done
    default: Writing superblocks and filesystem accounting information: done
    default: 
```

### Існуюча проблема:
Під час створення нового диска виникає проблема з конфігурацією Vagrant, оскільки мені не вдалося знайти правильного рішення для її усунення.

При виконанні команди vagrant destroy, а потім vagrant up або vagrant reload без видалення нового диска виникає проблема: диск уже був створений. Мені здається, що Vagrant не має повноцінного рішення для цієї ситуації.

Навіть при динамічному створенні дисків, наприклад, з різними назвами, виникає проблема несумісності даних (hash).
```
The following error was experienced:

#<Vagrant::Errors::VBoxManageError:"There was an error while executing `VBoxManage`, a CLI used by Vagrant\nfor controlling VirtualBox.
The command and stderr is shown below.\n\nCommand: [\"storagectl\", \"da41a7bb-95d9-40b6-98ca-4ef5c988341e\", \"--name\", \"SATA\", \"--add\", \"sata\", \"--controller\", \"IntelAHCI\"]\n\nStderr:
VBoxManage: error: Storage controller named 'SATA' already exists\nVBoxManage: error:
Details: code VBOX_E_OBJECT_IN_USE (0x80bb000c), component SessionMachine, interface IMachine, callee nsISupports\nVBoxManage: error:
Context: \"AddStorageController(Bstr(pszCtl).raw(), StorageBus_SATA, ctl.asOutParam())\" at line 1090 of file VBoxManageStorageController.cpp\n">

Please fix this customization and try again.
```


## Vagrant Конфігурація
```
    Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  config.vm.network "forwarded_port", guest: 22, host: 2222
  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024

    disk_name = "extra_disk.vdi"
    disk_path = File.join(File.expand_path("."), disk_name)
    disk_size = 1024 # in MB

    unless File.exist?(disk_path)
      vb.customize [
        "createhd",
        "--filename", disk_path,
        "--size", disk_size,
        "--variant", "Fixed"
      ]
    end

    vb.customize [
      "storagectl", :id,
      "--name", "SATA",
      "--add", "sata",
      "--controller", "IntelAHCI"
    ]

    vb.customize [
      "storageattach", :id,
      "--storagectl", "SATA",
      "--port", 1,
      "--device", 0,
      "--type", "hdd",
      "--medium", disk_path
    ]
  end

  config.vm.provision "setup_nginx", type: "shell", inline: <<-SHELL
    echo "Running apt update..."
    apt-get -y update
    echo "Installing software-properties-common..."
    apt-get -y install software-properties-common

    echo "Installing Nginx from official Ubuntu repo..."
    apt-get -y install nginx
    echo "Initial Nginx version:"
    nginx -v

    echo "Adding PPA: ondrej/nginx"
    add-apt-repository -y ppa:ondrej/nginx
    echo "Installing PPA-purge..."
    apt-get -y install ppa-purge

    echo "Reverting to default Nginx using PPA-purge..."
    ppa-purge -y ppa:ondrej/nginx
    echo "Final Nginx version:"
    nginx -v
    echo "✅ Nginx installation and cleanup complete."
  SHELL

  config.vm.provision "configure_firewall", type: "shell", inline: <<-SHELL
    echo "Installing and configuring UFW and Fail2Ban..."

    apt-get update -y
    apt-get install -y ufw fail2ban

    ufw allow in on eth0 to any port 22 proto tcp
    ufw allow from 192.168.1.10 to any port 22 proto tcp
    ufw deny from 192.168.1.11 to any port 22 proto tcp

    ufw --force enable
    ufw status numbered

    cat <<EOF > /etc/fail2ban/jail.d/ssh.local
[sshd]
enabled = true
maxretry = 3
findtime = 1d
bantime = 1w
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

    systemctl restart fail2ban
    systemctl enable fail2ban

    echo "✅ Fail2Ban status:"
    fail2ban-client status sshd

    echo "Pinging Fail2Ban..."
    fail2ban-client ping

    echo "Manually banning test IPs..."
    fail2ban-client set sshd banip 192.168.1.11
    fail2ban-client set sshd banip 192.168.1.12
    fail2ban-client set sshd banip 192.168.1.13

    echo "✅ Final Fail2Ban status:"
    fail2ban-client status sshd
  SHELL

  config.vm.provision "setup_disk", type: "shell", inline: <<-SHELL
    apt-get update -y
    apt-get install -y parted

    parted /dev/sdb --script mklabel gpt
    parted /dev/sdb --script mkpart primary ext4 0% 100%
    mkfs.ext4 /dev/sdb1

    mkdir -p /mnt/data
    mount /dev/sdb1 /mnt/data
    echo "/dev/sdb1 /mnt/data ext4 defaults 0 0" >> /etc/fstab

    chown vagrant:vagrant /mnt/data
  SHELL

  config.vm.provision "time-logger", type: "shell", inline: <<-SHELL
    echo "Setting up log-time.sh systemd timer..."

    cp /vagrant/systemd/log-time.sh /usr/local/bin/log-time.sh
    chmod +x /usr/local/bin/log-time.sh

    touch /mnt/data/output.txt

    cp /vagrant/systemd/log-time.service /etc/systemd/system/log-time.service
    cp /vagrant/systemd/log-time.timer /etc/systemd/system/log-time.timer

    systemctl daemon-reexec
    systemctl daemon-reload
    systemctl enable --now log-time.timer

    echo "✅ log-time.timer enabled and running."
  SHELL
end
```