#! /bin/bash

# Start both OVS and OVN services
sudo /usr/local/share/openvswitch/scripts/ovs-ctl start --system-id="ovn"
sudo /usr/local/share/ovn/scripts/ovn-ctl start_ovsdb --db-nb-create-insecure-remote=yes --db-sb-create-insecure-remote=yes
sudo /usr/local/share/ovn/scripts/ovn-ctl start_northd
sudo /usr/local/share/ovn/scripts/ovn-ctl start_controller
