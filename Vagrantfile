Vagrant.configure("2") do |config|
  config.vm.define "publicVM" do |public_vm|
    public_vm.vm.box = "bento/ubuntu-24.04"
    public_vm.vm.box_version = "202502.21.0"

    public_vm.vm.provider "virtualbox" do |vb|
      vb.name = 'Public Network Virtual Box Machine'
    end

    public_vm.vm.network "public_network", bridge: "en0: Wi-Fi"
    public_vm.vm.synced_folder ".", "/vagrant"

    public_vm.vm.provision "shell", inline: <<-SHELL
      echo "Initialized apt-update..."
      apt-get update
      echo "Installing apache2..."
      apt-get install -y apache2
    SHELL
  end
  config.vm.define "privateVM" do |private_vm|
    private_vm.vm.box = "bento/ubuntu-24.04"
    private_vm.vm.box_version = "202502.21.0"
    private_vm.vm.provider "virtualbox" do |vb|
      vb.name = 'Private Network Virtual Box Machine'
    end
    private_vm.vm.network "private_network", ip: "192.168.33.10"

    private_vm.vm.synced_folder ".", "/vagrant"

    private_vm.vm.provision "shell", inline: <<-SHELL
      echo "Initialized apt-update..."
      apt-get update
      echo "Installing cowsay..."
      apt-get install -y cowsay
    SHELL
  end

  config.vm.define "staticVM" do |static_vm|
    static_vm.vm.box = "bento/ubuntu-24.04"
    static_vm.vm.box_version = "202502.21.0"

    static_vm.vm.provider "virtualbox" do |vb|
      vb.name = 'Static Network Virtual Box Machine'
    end

    config.ssh.forward_agent = true

    static_vm.vm.network "forwarded_port", guest: 3000, host: 3000
    static_vm.vm.synced_folder "./data", "/vagrant"

    static_vm.vm.provision "shell", inline: <<-SHELL
      echo "✅ Updating apt..."
      apt-get update -y

      echo "📦 Installing required packages..."
      apt-get install -y git curl

      echo "🧰 Installing Node.js (LTS)..."
      curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
      apt-get install -y nodejs

      echo "🔁 Cloning Next.js project if not already present..."
      if [ ! -d "/home/vagrant/parshop-anton" ]; then
        cd /home/vagrant
        git clone https://github.com/Hibanaga/parshop-anton.git
      else
        echo "✔️ Project already cloned"
      fi

      echo "📁 Installing dependencies..."
      cd /home/vagrant/parshop-anton
      npm install

      echo "🚀 Starting Next.js app..."
      nohup npm run dev -- --port 3000 --hostname 0.0.0.0 > /home/vagrant/next.log 2>&1 &

      echo "http://localhost:3000"
    SHELL
  end
end


# Vagrant.configure("2") do |config|
#   (1..3).each do |i|
#     config.vm.define "VM-#{i}" do |virtual|
#       virtual.vm.box = "bento/ubuntu-24.04"
#       virtual.vm.box_version = "202502.21.0"
#
#       virtual.vm.provider "virtualbox" do |vb|
#         vb.name = "Virtual Machine ##{i}"
#       end
#
#       virtual.vm.network "public_network", bridge: "en0: Wi-Fi"
#       virtual.vm.synced_folder ".", "/vagrant"
#
#       virtual.vm.provision "shell", inline: <<-SHELL
#         echo "Initialized apt-update..."
#         apt-get update -y
#
#         echo "Installing cowsay..."
#         apt-get install -y cowsay
#
#         echo "Execute cowsay..."
#         cowsay "Virtual Machine ##{i} with Public Network is ready!"
#       SHELL
#     end
#   end
# end
