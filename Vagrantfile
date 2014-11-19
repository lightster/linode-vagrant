# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/centos-7.0"
  #config.vm.box_url = "metadata.json"
  #config.vm.box_download_insecure = true

  config.ssh.forward_agent = true
  #config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network "private_network", ip: "192.168.50.12"

  # prevent the default /vagrant share from being created
  # since bindfs will handle this share
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.synced_folder ".", "/vagrant-nfs",
    :type => :nfs
  config.bindfs.bind_folder "/vagrant-nfs", "/vagrant",
    :perms => "u=rwx:g=rwx:o=rD",
    :group => "apache",
    :'chmod-ignore' => true,
    :'chown-ignore' => true,
    :'chgrp-ignore' => true,
    :'create-with-perms' => "u=rwx:g=rwx:o=rD"

#  config.vm.provider :virtualbox do |vb|
#    vb.auto_nat_dns_proxy = false
#    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off" ]
#    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off" ]
#  end

  #config.vm.box_check_update = false
end

