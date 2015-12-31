# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  settings = { }
  Dir.glob(__dir__ + "/config/autoload/*.defaults.json").each do |config_file|
    settings = settings.merge(JSON::load(File.read(config_file)))
  end
  Dir.glob(__dir__ + "/config/autoload/*.overrides.json").each do |config_file|
    settings = settings.merge(JSON::load(File.read(config_file)))
  end

  config.vm.box = "../box-packer/builds/virtualbox/vagrant-centos-7-20150815-01.box"
  #config.vm.box_url = "metadata.json"
  #config.vm.box_download_insecure = true

  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.vm.provision :shell do |s|
    s.path = "bin/vagrant/stackscript.sh"
    s.env = {
      "KEEPER_PASSWORD" => "vagrant"
    }
  end
  config.vm.provision :shell, path: "bin/vagrant/directory_structure.sh"

  # prevent the default /vagrant share from being created
  # since bindfs will handle this share
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.synced_folder ".", "/vagrant-nfs",
    :type => :nfs
  config.bindfs.bind_folder "/vagrant-nfs", "/vagrant",
    :perms => "u=rwx:g=rwx:o=rD",
    :owner => settings["bindfs_owner"],
    :group => settings["bindfs_group"],
    :'chmod-ignore' => true,
    :'chown-ignore' => true,
    :'chgrp-ignore' => true,
    :'create-with-perms' => "u=rwx:g=rwx:o=rD"

  config.vm.provider :virtualbox do |vb|
    if settings["bypass_nat_dns"] then
      vb.auto_nat_dns_proxy = false
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "off" ]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off" ]
    end
  end

  #config.vm.box_check_update = false
  settings["machines"].each do |machine_name, machine_settings|
    config.vm.define machine_name, primary: machine_name == settings["primary_machine"] do |host|
      host.vm.network "private_network", ip: machine_settings["ip"]
      host.vm.hostname = "#{machine_name}.l.com"
    end
  end
end

