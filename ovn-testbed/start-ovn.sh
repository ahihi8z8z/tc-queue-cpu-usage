#! /bin/bash

# Start both OVS and OVN services
sudo /usr/local/share/openvswitch/scripts/ovs-ctl restart --system-id="ovn"
sudo /usr/local/share/ovn/scripts/ovn-ctl restart_ovsdb --db-nb-create-insecure-remote=yes --db-sb-create-insecure-remote=yes
sudo /usr/local/share/ovn/scripts/ovn-ctl restart_northd
sudo /usr/local/share/ovn/scripts/ovn-ctl restart_controller
