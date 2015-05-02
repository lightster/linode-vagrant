# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

config_defaults_file = "config.defaults.json"
config_overrides_file = "config.overrides.json"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  settings = { }
  if File.exists? config_defaults_file then
    settings = settings.merge(JSON::load(File.read(config_defaults_file)))
  end
  if File.exists? config_overrides_file then
    settings = settings.merge(JSON::load(File.read(config_overrides_file)))
  end

  config.vm.box = "../box-packer/builds/virtualbox/vagrant-centos-7.0-20150424-01.box"
  #config.vm.box_url = "metadata.json"
  #config.vm.box_download_insecure = true

  config.ssh.forward_agent = true
  config.vm.provision :shell, path: "stackscript.sh"

  # prevent the default /vagrant share from being created
  # since bindfs will handle this share
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.synced_folder ".", "/vagrant-nfs",
    :type => :nfs
  config.bindfs.bind_folder "/vagrant-nfs", "/vagrant",
    :perms => "u=rwx:g=rwx:o=rD",
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
    config.vm.define machine_name do |host|
      host.vm.network "private_network", ip: machine_settings["ip"]
      host.vm.hostname = "#{machine_name}.l.com"
    end
  end
end

