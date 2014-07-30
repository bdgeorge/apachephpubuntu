Vagrant.configure("2") do |config|

    config.vm.provider :virtualbox do |vb|
      # This allows symlinks to be created within the /vagrant root directory,
      # which is something librarian-puppet needs to be able to do. This might
      # be enabled by default depending on what version of VirtualBox is used.
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    # This shell provisioner installs librarian-puppet and runs it to install
    # puppet modules. This has to be done before the puppet provisioning so that
    # the modules are available when puppet tries to parse its manifests.
    config.vm.provision :shell, :path => "shell/main.sh"

    # Enable the Puppet provisioner, with will look in manifests
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "main.pp"
        puppet.module_path = "puppet/modules"
    end

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "ubuntu/trusty32"

    # Forward guest port 80 to host port 8888 and name mapping
    config.vm.network "private_network", ip: "192.168.50.3"

    config.vm.synced_folder "web/", "/vagrant/web/", owner: "www-data", group: "www-data"
    config.vm.synced_folder "database/", "/vagrant/database/", :owner => "vagrant"

    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end

    # config.vm.provision :shell, :path => "shell/postinstall.sh"

    config.vm.provision "shell",
        inline: "echo Box up and provisioned"
end
