Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.synced_folder ".", "/vagrant", disabled: false

  # VirtualBox setup with an additional disk
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

  config.vm.provision "time-logger", type: "shell", inline: <<-SHELL
    echo "Setting up log-time.sh systemd timer..."

    cp /vagrant/systemd/log-time.sh /usr/local/bin/log-time.sh
    chmod +x /usr/local/bin/log-time.sh

    touch /mnt/data/output.txt
    chown vagrant:vagrant /mnt/data/output.txt

    cp /vagrant/systemd/log-time.service /etc/systemd/system/log-time.service
    cp /vagrant/systemd/log-time.timer /etc/systemd/system/log-time.timer

    systemctl daemon-reexec
    systemctl daemon-reload
    systemctl enable --now log-time.timer

    echo "✅ log-time.timer enabled and running."
  SHELL
end
