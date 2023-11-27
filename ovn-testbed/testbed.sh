#! /bin/bash

# Create ovn logical topo
sudo ovn-nbctl ls-add network1
sudo ovn-nbctl lsp-add network1 vm1
sudo ovn-nbctl lsp-add network1 vm2
sudo ovn-nbctl lsp-set-addresses vm1 "40:44:00:00:00:01 10.0.0.1"
sudo ovn-nbctl lsp-set-addresses vm2 "40:44:00:00:00:02 10.0.0.2"
sudo ovn-nbctl show

# Create OVS binding
sudo ovs-vsctl add-port br-int vm1 -- set Interface vm1 type=internal -- set Interface vm1 external_ids:iface-id=vm1
sudo ovs-vsctl add-port br-int vm2 -- set Interface vm2 type=internal -- set Interface vm2 external_ids:iface-id=vm2
sudo ovn-sbctl show

#Create namespace vm1
sudo ip netns add vm1
sudo ip link set vm1 netns vm1
sudo ip netns exec vm1 ip link set vm1 address 40:44:00:00:00:01
sudo ip netns exec vm1 ip addr add 10.0.0.1/24 dev vm1
sudo ip netns exec vm1 ip link set vm1 up

#Create namespace vm2
sudo ip netns add vm2
sudo ip link set vm2 netns vm2
sudo ip netns exec vm2 ip link set vm2 address 40:44:00:00:00:02
sudo ip netns exec vm2 ip addr add 10.0.0.2/24 dev vm2
sudo ip netns exec vm2 ip link set vm2 up


