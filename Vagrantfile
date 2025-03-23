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

end