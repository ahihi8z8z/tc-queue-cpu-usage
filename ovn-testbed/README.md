- Mininet install: http://mininet.org/download/
- Run
```
sudo mn --custom ./custom.py --topo=myTopo
```
- Install 2 VMs with 2 interfaces:
	- Fisrt interface is default network "NAT" to access internet.
	- Second interface is bridge network with sample config:
```
interface type="bridge">
  <mac address="52:54:00:87:51:89"/>
  <source bridge="s1"/>
  <virtualport type="openvswitch"/>
  <model type="virtio"/>
  <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
</interface>
```
- Power on VMs:
        - With second interface, It must have static IP
- In mininet console, run "links", result will be like:
```
s1-eth1<->s2-eth1 (OK OK) 
s1-eth2<->s3-eth1 (OK OK) 
s2-eth2<->s3-eth2 (OK OK)
```
- In host console, get ofport number:
```
sudo ovs-vsctl -- --columns=name,ofport list Interface
```
- In host console, set flow in OVS switch:
```
sudo ovs-ofctl add-flow s1 in_port=2,actions=4
....
```
- Install k8s cluster, each cluster component (master and workers) must use second interface's IP address: https://medium.com/@kanrangsan/how-to-specify-internal-ip-for-kubernetes-worker-node-24790b2884fd.
- Ping between 2 pods in diffirent node to check connection.
