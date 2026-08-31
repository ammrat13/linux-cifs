# Linux RDMA Hang: Infrastructure

I discovered and patched a hang in the Linux kernel's RDMA code. This repository
contains the scripts I used to locally reproduce the hang and validate my patch.

The contents of my patch are under `patch/`. On the mailing lists, see:

- [[PATCH 0/2] smbdirect: don't hang on netdev reconfiguration][v0]

The patched kernel itself is a submodule. Its repository is
[github:ammrat13/linux-cifs-kernel][sub].

## Results

The kernel configurations I used are in `kernel/config/`. As my baseline, I used
commit `2beb1b31a12b`. The "bad" kernel is the baseline, and the "good" kernel
just has my patch applied. See `kernel/README.md` for what these kernels
actually map to.

The results themselves are in `results/`. See `results/README.md` for more
details.

## Usage

When testing, I ran client and server VMs. I had them both as well as the host
on a bridge device.

To reproduce the hang or validate the patch, you must

1. Configure `variables.json` and `password.json`
2. Configure the VMs and the host machine
3. Build the kernel
4. Build the disk images
5. Reproduce

Steps 2-5 are explained in the `README.md`s for the `virtxml/`, `kernel/`,
`image/`, and `repro/` folders respectively. Step 1 is explained below.

### Step 1: Configure `variables.json` and `password.json`

The variables defined in these files will be passed through to both Packer in
Step 4 and Ansible in Step 5. The following variables must be configured:

- Credentials:
  - `vm_username`: username to log-in to the server or the client VMs
  - `vm_password`: password to log-in to the server or the client VMs as
    `vm_username`
- Hostname:
  - `vm_hostname_prefix`: prefix to put on either "client" or "server" to get
    the hostname
- Network Addresses: These are the statically-configured addresses on the
  bridge. They should all be on the `192.168.45.0/24` subnet to match the
  virtxml in Step 2.
  - `host_address`: IP and Mask of the host, in CIDR notation. Used for NAT.
    Should be `192.168.45.1/24` to match the virtxml in Step 2.
  - `server_address`: IP and Mask of the server, in CIDR notation
  - `client_address`: IP and Mask of the client, in CIDR notation
- `vm_interface`: network interface used inside the VMs. Should be `enp16s0`
  to match the virtxml in Step 2
- `server_share`: name of the CIFS share exposed by the server

Most of the mandatory variables are already in `variables.json`.

*Action Items:*

- Configure `vm_password` in `password.json`, using `password.example.json` as a
  template

### Steps 2-5

See the `README.md` files in:

<!-- markdownlint-disable MD029 -->
2. `virtxml/`
3. `kernel/`
4. `image/`
5. `repro/`
<!-- markdownlint-restore -->

Note that the commands in these files are still relative to the repository root.

[sub]:
  https://github.com/ammrat13/linux-cifs-kernel/tree/infiniband/disconnect-on-dreq-drep-error
  "ammrat13/linux-cifs-kernel at infiniband/disconnect-on-dreq-drep-error - GitHub"
[v0]:
  https://lore.kernel.org/linux-rdma/20260908154454.10966-1-ammrat13@gmail.com/
  "[PATCH 0/2] smbdirect: don't hang on netdev reconfiguration"
