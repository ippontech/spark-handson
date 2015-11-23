# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/vivid64"

  config.ssh.password = "vagrant"

  config.vm.network :private_network, ip: "192.168.51.10"
  config.vm.network :forwarded_port, guest: 22, host: 1233
  config.vm.network :forwarded_port, guest: 9000, host: 9001

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Spark Hands On"

    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
  
    # Customize the VM:
    vb.memory = "2048"
    vb.cpus = 4
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
