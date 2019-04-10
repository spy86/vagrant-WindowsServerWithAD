Vagrant.configure("2") do |config|
    config.vm.box = "windows-2019-amd64"
    config.vm.define "windows-domain-controller"
    config.vm.hostname = "dc"

    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true

    config.vm.provider :libvirt do |lv, config|
        lv.memory = 2048
        lv.cpus = 2
        lv.cpu_mode = 'host-passthrough'
        lv.keymap = 'pt'

        config.vm.synced_folder '.', '/vagrant', type: 'smb', smb_username: ENV['USER'], smb_password: ENV['VAGRANT_SMB_PASSWORD']
    end

    config.vm.provider :virtualbox do |v, override|
        v.linked_clone = true
        v.cpus = 2
        v.memory = 2048
        v.customize ["modifyvm", :id, "--vram", 64]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        v.customize ["storageattach", :id,
                        "--storagectl", "IDE Controller",
                        "--device", "0",
                        "--port", "1",
                        "--type", "dvddrive",
                        "--medium", "emptydrive"]
    end

    config.vm.network "private_network", ip: "192.168.56.2", libvirt__forward_mode: "route", libvirt__dhcp_enabled: false

    config.vm.provision "shell", path: "provision/ps.ps1", args: "domain-controller.ps1"
    config.vm.provision "reload"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "domain-controller-configure.ps1"
    config.vm.provision "shell", inline: "$env:chocolateyVersion='0.10.11'; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex", name: "Install Chocolatey"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "provision-base.ps1"
    config.vm.provision "reload"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "ad-explorer.ps1"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "ca.ps1"
    config.vm.provision "reload"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "summary.ps1"
end
