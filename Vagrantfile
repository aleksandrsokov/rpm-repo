# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "almalinux/9"
  config.vm.box_version = "9.3.20231118"
  config.vm.box_check_update = false
  config.vm.hostname = "rpm.local"
  config.vm.network "forwarded_port", guest: 80, host: 8888, protocol: "tcp"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = "2"
   end

  config.vm.provision "shell", inline: <<-SHELL
     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
     systemctl restart sshd.service
    SHELL
  config.vm.provision "shell", path: "install.sh"
  # config.vm.provision "shell", inline: <<-SHELL
  #   
  # SHELL
end
