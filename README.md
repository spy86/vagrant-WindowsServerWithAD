# Vagrantbox Windows Server with AD Controller

![Vagrant](https://img.shields.io/badge/vagrant-WindowsServerWithAD-orange.svg) ![Vagrant](https://img.shields.io/github/issues/spy86/vagrant-WindowsServerWithAD.svg) ![Vagrant](https://img.shields.io/github/forks/spy86/vagrant-WindowsServerWithAD.svg) ![Vagrant](https://img.shields.io/github/stars/spy86/vagrant-WindowsServerWithAD.svg) ![Vagrant](https://img.shields.io/github/license/spy86/vagrant-WindowsServerWithAD.svg) ![Vagrant](https://img.shields.io/twitter/url/https/github.com/spy86/vagrant-WindowsServerWithAD.svg?style=social) 

## Prerequisites
* Vagrant - https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.msi
* Virtualbox - http://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-Win.exe
* `vagrant-reload` plugin
* `vagrant-windows-sysprep` plugin

## How to use?

1. Clone https://github.com/spy86/vagrant-WindowsServerWithAD
2. Install the required Vagrant plugins:

```bash
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-windows-sysprep
```

3. Start Domain Controller environment:

```bash
vagrant up --provider=virtualbox # or --provider=libvirt
```

4. Launch Test Node One Computer environment:

```bash
cd test-node-one
vagrant up --provider=virtualbox # or --provider=libvirt
```

5. This setup will use the following IP addresses:

| IP           | Hostname                  | Description                |
|--------------|---------------------------|----------------------------|
| 192.168.56.2 | dc.example.com            | Domain Controller Computer |
| 192.168.56.3 | test-node-one.example.com | Test Computer              |

***

## Accounts for environment:

* Username `tom.bereen` and password `HeyH0Password`. - This account is also added to Domain Administrator.
* Username `kate.bereen` and password `HeyH0Password`.
* Username `Administrator` and password `HeyH0Password`. - This account is also added to Domain Administrator.
* Username `.\vagrant` and password `password`.
