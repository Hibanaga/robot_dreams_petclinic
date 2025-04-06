# HM 6 -> Bash scripting

## Vagrantfile
```
config.vm.provision "shell", path: "configuration.sh", run: "always"
```

## Bash
```
#!/bin/bash

set -e

apt-get -y update

function yell {
  echo "🔊 $(date +"%T") $1"
}

for package in 'nginx' 'curl' 'apache2' 'ufw' 'postgresql';
do
  if (dpkg -l $package); then
    yell "✅ Initialize update $package package";
    apt-get -y --only-upgrade install $package
    yell "✅ $package successfully updated";
  else
    yell "🚀 Initialize install $package package"
    apt-get -y install $package
    yell "🚀 $package installed successfully"
  fi
done

yell "🎉 Configuration setup ended successfully"
```

## Logs
```
    default: Running: /var/folders/1d/z51v6z1d2px9f0rp0qcnm4kw0000gn/T/vagrant-shell20250406-21367-8i24x1.sh
    default: Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease [126 kB]
    default: Get:3 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease [126 kB]
    default: Get:4 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease [126 kB]
    default: Get:5 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 Packages [988 kB]
    default: Get:6 http://ports.ubuntu.com/ubuntu-ports noble-updates/main Translation-en [218 kB]
    default: Get:7 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 Components [148 kB]
    default: Get:8 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted arm64 Packages [1,048 kB]
    default: Get:9 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted Translation-en [180 kB]
    default: Get:10 http://ports.ubuntu.com/ubuntu-ports noble-updates/restricted arm64 Components [212 B]
    default: Get:11 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 Packages [1,020 kB]
    default: Get:12 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe Translation-en [265 kB]
    default: Get:13 http://ports.ubuntu.com/ubuntu-ports noble-updates/universe arm64 Components [364 kB]
    default: Get:14 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse arm64 Packages [16.9 kB]
    default: Get:15 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse Translation-en [4,788 B]
    default: Get:16 http://ports.ubuntu.com/ubuntu-ports noble-updates/multiverse arm64 Components [212 B]
    default: Get:17 http://ports.ubuntu.com/ubuntu-ports noble-backports/main arm64 Packages [39.1 kB]
    default: Get:18 http://ports.ubuntu.com/ubuntu-ports noble-backports/main Translation-en [8,676 B]
    default: Get:19 http://ports.ubuntu.com/ubuntu-ports noble-backports/main arm64 Components [3,568 B]
    default: Get:20 http://ports.ubuntu.com/ubuntu-ports noble-backports/restricted arm64 Components [216 B]
    default: Get:21 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe arm64 Packages [26.5 kB]
    default: Get:22 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe Translation-en [16.3 kB]
    default: Get:23 http://ports.ubuntu.com/ubuntu-ports noble-backports/universe arm64 Components [15.7 kB]
    default: Get:24 http://ports.ubuntu.com/ubuntu-ports noble-backports/multiverse arm64 Components [212 B]
    default: Get:25 http://ports.ubuntu.com/ubuntu-ports noble-security/main arm64 Packages [739 kB]
    default: Get:26 http://ports.ubuntu.com/ubuntu-ports noble-security/main Translation-en [141 kB]
    default: Get:27 http://ports.ubuntu.com/ubuntu-ports noble-security/main arm64 Components [5,696 B]
    default: Get:28 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted arm64 Packages [1,000 kB]
    default: Get:29 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted Translation-en [172 kB]
    default: Get:30 http://ports.ubuntu.com/ubuntu-ports noble-security/restricted arm64 Components [212 B]
    default: Get:31 http://ports.ubuntu.com/ubuntu-ports noble-security/universe arm64 Packages [802 kB]
    default: Get:32 http://ports.ubuntu.com/ubuntu-ports noble-security/universe Translation-en [180 kB]
    default: Get:33 http://ports.ubuntu.com/ubuntu-ports noble-security/universe arm64 Components [52.3 kB]
    default: Get:34 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse arm64 Packages [15.3 kB]
    default: Get:35 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse Translation-en [3,792 B]
    default: Get:36 http://ports.ubuntu.com/ubuntu-ports noble-security/multiverse arm64 Components [212 B]
    default: Fetched 7,853 kB in 2s (4,393 kB/s)
    default: Reading package lists...
    default: 🔊 11:56:07 ❌ Package abc doesn't exist. Skipping...
    default: dpkg-query: no packages found matching nginx
    default: 🔊 11:56:07 🚀 Initialize install nginx package
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: The following additional packages will be installed:
    default:   nginx-common
    default: Suggested packages:
    default:   fcgiwrap nginx-doc ssl-cert
    default: The following NEW packages will be installed:
    default:   nginx nginx-common
    default: 0 upgraded, 2 newly installed, 0 to remove and 95 not upgraded.
    default: Need to get 549 kB of archives.
    default: After this operation, 1,621 kB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 nginx-common all 1.24.0-2ubuntu7.3 [31.2 kB]
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 nginx arm64 1.24.0-2ubuntu7.3 [518 kB]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 549 kB in 0s (1,471 kB/s)
    default: Selecting previously unselected package nginx-common.
(Reading database ... 52381 files and directories currently installed.)
    default: Preparing to unpack .../nginx-common_1.24.0-2ubuntu7.3_all.deb ...
    default: Unpacking nginx-common (1.24.0-2ubuntu7.3) ...
    default: Selecting previously unselected package nginx.
    default: Preparing to unpack .../nginx_1.24.0-2ubuntu7.3_arm64.deb ...
    default: Unpacking nginx (1.24.0-2ubuntu7.3) ...
    default: Setting up nginx (1.24.0-2ubuntu7.3) ...
    default: Setting up nginx-common (1.24.0-2ubuntu7.3) ...
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
    default: 🔊 11:56:11 🚀 nginx installed successfully
    default: Desired=Unknown/Install/Remove/Purge/Hold
    default: | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
    default: |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
    default: ||/ Name           Version           Architecture Description
    default: +++-==============-=================-============-=======================================================
    default: ii  curl           8.5.0-2ubuntu10.6 arm64        command line tool for transferring data with URL syntax
    default: 🔊 11:56:11 ✅  Initialize update curl package
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: curl is already the newest version (8.5.0-2ubuntu10.6).
    default: 0 upgraded, 0 newly installed, 0 to remove and 95 not upgraded.
    default: 🔊 11:56:11 ✅  curl successfully updated
    default: dpkg-query: no packages found matching apache2
    default: 🔊 11:56:11 🚀 Initialize install apache2 package
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: The following additional packages will be installed:
    default:   apache2-bin apache2-data apache2-utils libapr1t64 libaprutil1-dbd-sqlite3
    default:   libaprutil1-ldap libaprutil1t64 liblua5.4-0 ssl-cert
    default: Suggested packages:
    default:   apache2-doc apache2-suexec-pristine | apache2-suexec-custom www-browser
    default: The following NEW packages will be installed:
    default:   apache2 apache2-bin apache2-data apache2-utils libapr1t64
    default:   libaprutil1-dbd-sqlite3 libaprutil1-ldap libaprutil1t64 liblua5.4-0 ssl-cert
    default: 0 upgraded, 10 newly installed, 0 to remove and 95 not upgraded.
    default: Need to get 2,064 kB of archives.
    default: After this operation, 14.0 MB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 libapr1t64 arm64 1.7.2-3.1ubuntu0.1 [106 kB]
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libaprutil1t64 arm64 1.6.3-1.1ubuntu7 [93.9 kB]
    default: Get:3 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libaprutil1-dbd-sqlite3 arm64 1.6.3-1.1ubuntu7 [11.2 kB]
    default: Get:4 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libaprutil1-ldap arm64 1.6.3-1.1ubuntu7 [9,046 B]
    default: Get:5 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 liblua5.4-0 arm64 5.4.6-3build2 [158 kB]
    default: Get:6 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 apache2-bin arm64 2.4.58-1ubuntu8.5 [1,319 kB]
    default: Get:7 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 apache2-data all 2.4.58-1ubuntu8.5 [163 kB]
    default: Get:8 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 apache2-utils arm64 2.4.58-1ubuntu8.5 [96.3 kB]
    default: Get:9 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 apache2 arm64 2.4.58-1ubuntu8.5 [90.2 kB]
    default: Get:10 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 ssl-cert all 1.1.2ubuntu1 [17.8 kB]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 2,064 kB in 0s (4,589 kB/s)
    default: Selecting previously unselected package libapr1t64:arm64.
(Reading database ... 52429 files and directories currently installed.)
    default: Preparing to unpack .../0-libapr1t64_1.7.2-3.1ubuntu0.1_arm64.deb ...
    default: Unpacking libapr1t64:arm64 (1.7.2-3.1ubuntu0.1) ...
    default: Selecting previously unselected package libaprutil1t64:arm64.
    default: Preparing to unpack .../1-libaprutil1t64_1.6.3-1.1ubuntu7_arm64.deb ...
    default: Unpacking libaprutil1t64:arm64 (1.6.3-1.1ubuntu7) ...
    default: Selecting previously unselected package libaprutil1-dbd-sqlite3:arm64.
    default: Preparing to unpack .../2-libaprutil1-dbd-sqlite3_1.6.3-1.1ubuntu7_arm64.deb ...
    default: Unpacking libaprutil1-dbd-sqlite3:arm64 (1.6.3-1.1ubuntu7) ...
    default: Selecting previously unselected package libaprutil1-ldap:arm64.
    default: Preparing to unpack .../3-libaprutil1-ldap_1.6.3-1.1ubuntu7_arm64.deb ...
    default: Unpacking libaprutil1-ldap:arm64 (1.6.3-1.1ubuntu7) ...
    default: Selecting previously unselected package liblua5.4-0:arm64.
    default: Preparing to unpack .../4-liblua5.4-0_5.4.6-3build2_arm64.deb ...
    default: Unpacking liblua5.4-0:arm64 (5.4.6-3build2) ...
    default: Selecting previously unselected package apache2-bin.
    default: Preparing to unpack .../5-apache2-bin_2.4.58-1ubuntu8.5_arm64.deb ...
    default: Unpacking apache2-bin (2.4.58-1ubuntu8.5) ...
    default: Selecting previously unselected package apache2-data.
    default: Preparing to unpack .../6-apache2-data_2.4.58-1ubuntu8.5_all.deb ...
    default: Unpacking apache2-data (2.4.58-1ubuntu8.5) ...
    default: Selecting previously unselected package apache2-utils.
    default: Preparing to unpack .../7-apache2-utils_2.4.58-1ubuntu8.5_arm64.deb ...
    default: Unpacking apache2-utils (2.4.58-1ubuntu8.5) ...
    default: Selecting previously unselected package apache2.
    default: Preparing to unpack .../8-apache2_2.4.58-1ubuntu8.5_arm64.deb ...
    default: Unpacking apache2 (2.4.58-1ubuntu8.5) ...
    default: Selecting previously unselected package ssl-cert.
    default: Preparing to unpack .../9-ssl-cert_1.1.2ubuntu1_all.deb ...
    default: Unpacking ssl-cert (1.1.2ubuntu1) ...
    default: Setting up ssl-cert (1.1.2ubuntu1) ...
    default: Created symlink /etc/systemd/system/multi-user.target.wants/ssl-cert.service → /usr/lib/systemd/system/ssl-cert.service.
    default: Setting up libapr1t64:arm64 (1.7.2-3.1ubuntu0.1) ...
    default: Setting up liblua5.4-0:arm64 (5.4.6-3build2) ...
    default: Setting up apache2-data (2.4.58-1ubuntu8.5) ...
    default: Setting up libaprutil1t64:arm64 (1.6.3-1.1ubuntu7) ...
    default: Setting up libaprutil1-ldap:arm64 (1.6.3-1.1ubuntu7) ...
    default: Setting up libaprutil1-dbd-sqlite3:arm64 (1.6.3-1.1ubuntu7) ...
    default: Setting up apache2-utils (2.4.58-1ubuntu8.5) ...
    default: Setting up apache2-bin (2.4.58-1ubuntu8.5) ...
    default: Setting up apache2 (2.4.58-1ubuntu8.5) ...
    default: Enabling module mpm_event.
    default: Enabling module authz_core.
    default: Enabling module authz_host.
    default: Enabling module authn_core.
    default: Enabling module auth_basic.
    default: Enabling module access_compat.
    default: Enabling module authn_file.
    default: Enabling module authz_user.
    default: Enabling module alias.
    default: Enabling module dir.
    default: Enabling module autoindex.
    default: Enabling module env.
    default: Enabling module mime.
    default: Enabling module negotiation.
    default: Enabling module setenvif.
    default: Enabling module filter.
    default: Enabling module deflate.
    default: Enabling module status.
    default: Enabling module reqtimeout.
    default: Enabling conf charset.
    default: Enabling conf localized-error-pages.
    default: Enabling conf other-vhosts-access-log.
    default: Enabling conf security.
    default: Enabling conf serve-cgi-bin.
    default: Enabling site 000-default.
    default: Created symlink /etc/systemd/system/multi-user.target.wants/apache2.service → /usr/lib/systemd/system/apache2.service.
    default: Could not execute systemctl:  at /usr/bin/deb-systemd-invoke line 148.
    default: Created symlink /etc/systemd/system/multi-user.target.wants/apache-htcacheclean.service → /usr/lib/systemd/system/apache-htcacheclean.service.
    default: Processing triggers for ufw (0.36.2-6) ...
    default: Processing triggers for man-db (2.12.0-4build2) ...
    default: Processing triggers for libc-bin (2.39-0ubuntu8.4) ...
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
    default: 🔊 11:56:15 🚀 apache2 installed successfully
    default: Desired=Unknown/Install/Remove/Purge/Hold
    default: | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
    default: |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
    default: ||/ Name           Version      Architecture Description
    default: +++-==============-============-============-=========================================
    default: ii  ufw            0.36.2-6     all          program for managing a Netfilter firewall
    default: 🔊 11:56:16 ✅  Initialize update ufw package
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: ufw is already the newest version (0.36.2-6).
    default: 0 upgraded, 0 newly installed, 0 to remove and 95 not upgraded.
    default: 🔊 11:56:16 ✅  ufw successfully updated
    default: dpkg-query: no packages found matching postgresql
    default: 🔊 11:56:16 🚀 Initialize install postgresql package
    default: Reading package lists...
    default: Building dependency tree...
    default: Reading state information...
    default: The following additional packages will be installed:
    default:   libcommon-sense-perl libjson-perl libjson-xs-perl libllvm17t64 libpq5
    default:   libtypes-serialiser-perl postgresql-16 postgresql-client-16
    default:   postgresql-client-common postgresql-common
    default: Suggested packages:
    default:   postgresql-doc postgresql-doc-16
    default: The following NEW packages will be installed:
    default:   libcommon-sense-perl libjson-perl libjson-xs-perl libllvm17t64 libpq5
    default:   libtypes-serialiser-perl postgresql postgresql-16 postgresql-client-16
    default:   postgresql-client-common postgresql-common
    default: 0 upgraded, 11 newly installed, 0 to remove and 95 not upgraded.
    default: Need to get 42.2 MB of archives.
    default: After this operation, 176 MB of additional disk space will be used.
    default: Get:1 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libjson-perl all 4.10000-1 [81.9 kB]
    default: Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 postgresql-client-common all 257build1.1 [36.4 kB]
    default: Get:3 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 postgresql-common all 257build1.1 [161 kB]
    default: Get:4 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libcommon-sense-perl arm64 3.75-3build3 [20.4 kB]
    default: Get:5 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libtypes-serialiser-perl all 1.01-1 [11.6 kB]
    default: Get:6 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libjson-xs-perl arm64 4.030-2build3 [83.1 kB]
    default: Get:7 http://ports.ubuntu.com/ubuntu-ports noble/main arm64 libllvm17t64 arm64 1:17.0.6-9ubuntu1 [25.0 MB]
    default: Get:8 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 libpq5 arm64 16.8-0ubuntu0.24.04.1 [140 kB]
    default: Get:9 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 postgresql-client-16 arm64 16.8-0ubuntu0.24.04.1 [1,282 kB]
    default: Get:10 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 postgresql-16 arm64 16.8-0ubuntu0.24.04.1 [15.3 MB]
    default: Get:11 http://ports.ubuntu.com/ubuntu-ports noble-updates/main arm64 postgresql all 16+257build1.1 [11.6 kB]
    default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
    default: Fetched 42.2 MB in 1s (40.4 MB/s)
    default: Selecting previously unselected package libjson-perl.
(Reading database ... 53152 files and directories currently installed.)
    default: Preparing to unpack .../00-libjson-perl_4.10000-1_all.deb ...
    default: Unpacking libjson-perl (4.10000-1) ...
    default: Selecting previously unselected package postgresql-client-common.
    default: Preparing to unpack .../01-postgresql-client-common_257build1.1_all.deb ...
    default: Unpacking postgresql-client-common (257build1.1) ...
    default: Selecting previously unselected package postgresql-common.
    default: Preparing to unpack .../02-postgresql-common_257build1.1_all.deb ...
    default: Adding 'diversion of /usr/bin/pg_config to /usr/bin/pg_config.libpq-dev by postgresql-common'
    default: Unpacking postgresql-common (257build1.1) ...
    default: Selecting previously unselected package libcommon-sense-perl:arm64.
    default: Preparing to unpack .../03-libcommon-sense-perl_3.75-3build3_arm64.deb ...
    default: Unpacking libcommon-sense-perl:arm64 (3.75-3build3) ...
    default: Selecting previously unselected package libtypes-serialiser-perl.
    default: Preparing to unpack .../04-libtypes-serialiser-perl_1.01-1_all.deb ...
    default: Unpacking libtypes-serialiser-perl (1.01-1) ...
    default: Selecting previously unselected package libjson-xs-perl.
    default: Preparing to unpack .../05-libjson-xs-perl_4.030-2build3_arm64.deb ...
    default: Unpacking libjson-xs-perl (4.030-2build3) ...
    default: Selecting previously unselected package libllvm17t64:arm64.
    default: Preparing to unpack .../06-libllvm17t64_1%3a17.0.6-9ubuntu1_arm64.deb ...
    default: Unpacking libllvm17t64:arm64 (1:17.0.6-9ubuntu1) ...
    default: Selecting previously unselected package libpq5:arm64.
    default: Preparing to unpack .../07-libpq5_16.8-0ubuntu0.24.04.1_arm64.deb ...
    default: Unpacking libpq5:arm64 (16.8-0ubuntu0.24.04.1) ...
    default: Selecting previously unselected package postgresql-client-16.
    default: Preparing to unpack .../08-postgresql-client-16_16.8-0ubuntu0.24.04.1_arm64.deb ...
    default: Unpacking postgresql-client-16 (16.8-0ubuntu0.24.04.1) ...
    default: Selecting previously unselected package postgresql-16.
    default: Preparing to unpack .../09-postgresql-16_16.8-0ubuntu0.24.04.1_arm64.deb ...
    default: Unpacking postgresql-16 (16.8-0ubuntu0.24.04.1) ...
    default: Selecting previously unselected package postgresql.
    default: Preparing to unpack .../10-postgresql_16+257build1.1_all.deb ...
    default: Unpacking postgresql (16+257build1.1) ...
    default: Setting up postgresql-client-common (257build1.1) ...
    default: Setting up libpq5:arm64 (16.8-0ubuntu0.24.04.1) ...
    default: Setting up libcommon-sense-perl:arm64 (3.75-3build3) ...
    default: Setting up libllvm17t64:arm64 (1:17.0.6-9ubuntu1) ...
    default: Setting up libtypes-serialiser-perl (1.01-1) ...
    default: Setting up libjson-perl (4.10000-1) ...
    default: Setting up libjson-xs-perl (4.030-2build3) ...
    default: Setting up postgresql-client-16 (16.8-0ubuntu0.24.04.1) ...
    default: update-alternatives: using /usr/share/postgresql/16/man/man1/psql.1.gz to provide /usr/share/man/man1/psql.1.gz (psql.1.gz) in auto mode
    default: Setting up postgresql-common (257build1.1) ...
    default: 
    default: Creating config file /etc/postgresql-common/createcluster.conf with new version
    default: Building PostgreSQL dictionaries from installed myspell/hunspell packages...
    default: Removing obsolete dictionary files:
    default: Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /usr/lib/systemd/system/postgresql.service.
    default: Setting up postgresql-16 (16.8-0ubuntu0.24.04.1) ...
    default: Creating new PostgreSQL cluster 16/main ...
    default: /usr/lib/postgresql/16/bin/initdb -D /var/lib/postgresql/16/main --auth-local peer --auth-host scram-sha-256 --no-instructions
    default: The files belonging to this database system will be owned by user "postgres".
    default: This user must also own the server process.
    default: 
    default: The database cluster will be initialized with locale "en_US.UTF-8".
    default: The default database encoding has accordingly been set to "UTF8".
    default: The default text search configuration will be set to "english".
    default: 
    default: Data page checksums are disabled.
    default: 
    default: fixing permissions on existing directory /var/lib/postgresql/16/main ... ok
    default: creating subdirectories ... ok
    default: selecting dynamic shared memory implementation ... posix
    default: selecting default max_connections ... 100
    default: selecting default shared_buffers ... 128MB
    default: selecting default time zone ... Etc/UTC
    default: creating configuration files ... ok
    default: running bootstrap script ... ok
    default: performing post-bootstrap initialization ... ok
    default: syncing data to disk ... ok
    default: Setting up postgresql (16+257build1.1) ...
    default: Processing triggers for man-db (2.12.0-4build2) ...
    default: Processing triggers for libc-bin (2.39-0ubuntu8.4) ...
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
    default: 🔊 11:56:24 🚀 postgresql installed successfully
    default: 🔊 11:56:24 🎉 Configuration setup ended successfully
```