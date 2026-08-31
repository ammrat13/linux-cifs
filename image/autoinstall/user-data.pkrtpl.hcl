#cloud-config

autoinstall:
  version: 1
  locale: en_US.UTF-8
  keyboard:
    layout: us

  # Set a default hostname for now. We'll change it later in the Ansible.
  identity:
    hostname: "linux-cifs"
    username: "${username}"
    password: "${password-hash}"

  ssh:
    install-server: true
    allow-pw: true
