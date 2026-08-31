# Linux RDMA Hang: Configure the VMs and the Host Machine

I used libvirt to create QEMU VMs for the client and the server. Both of them
use PCIe VirtIO network devices, with RDMA done over RXE.

They both use the network device at PCIe Port 0x10 Slot 0x00. They use a bridge
(named `linuxcifsbr0`) to communicate with each other, and a NAT via the host to
connect to the internet. It's statically configured. I assigned:

- `192.168.45.1/24` to the host
- `192.168.45.10/24` to the server
- `192.168.45.20/24` to the client

*Action Items:* Run

```sh
sudo virsh net-define virtxml/network.xml
sudo virsh define virtxml/server.xml
sudo virsh define virtxml/client.xml
```
