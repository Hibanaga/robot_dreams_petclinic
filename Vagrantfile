disk_path = File.expand_path("./extra_disk.vdi")
disk_size = 1024
create_disk = !File.exist?(disk_path)

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder ".", "/vagrant", disabled: false

#   config.vm.provider "virtualbox" do |vb|
#     if create_disk
#       vb.customize [
#         "createhd",
#         "--filename", disk_path,
#         "--size", disk_size,
#         "--variant", "Fixed"
#       ]
#     end
#
#     vb.customize [
#       "storageattach", :id,
#       "--storagectl", "SATA",
#       "--port", 1,
#       "--device", 0,
#       "--type", "hdd",
#       "--medium", disk_path
#     ]
#   end
#
#   config.vm.provision "setup_disk", type: "shell", inline: <<-SHELL
#     echo "Updating APT and installing required tools..."
#     apt-get update -y
#     apt-get install -y parted
#
#     if ! lsblk | grep -q "sdb1"; then
#       echo "Creating partition on new disk..."
#       parted /dev/sdb --script mklabel gpt
#       parted /dev/sdb --script mkpart primary ext4 0% 100%
#
#       echo "Formatting partition as ext4..."
#       mkfs.ext4 /dev/sdb1
#     else
#       echo "⚠Partition /dev/sdb1 already exists. Skipping partitioning and formatting."
#     fi
#
#     echo "Creating mount point..."
#     mkdir -p /mnt/data
#
#     echo "Mounting partition..."
#     mount /dev/sdb1 /mnt/data
#
#     echo "Ensuring /etc/fstab contains mount entry..."
#     grep -q "/mnt/data" /etc/fstab || echo "/dev/sdb1 /mnt/data ext4 defaults 0 0" >> /etc/fstab
#
#     echo "Disk ready and mounted at /mnt/data"
#   SHELL

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
end
