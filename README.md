# Virtual Machine for the labs

## Requirements

- VirtualBox
- Vagrant
- Ansible

## Setting up the VM

Install Ansible roles:

```
ansible-galaxy install -r requirements.yml -p roles
```

Build the VM:

```
vagrant up
```

Once done, access Zeppelin from your browser (on the host): http://localhost:8081/
