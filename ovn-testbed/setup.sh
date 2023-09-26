#! /bin/bash

OVS_REPO=${GIT_REPO:-https://github.com/openvswitch/ovs.git}
OVS_BRANCH=${GIT_BRANCH:-1d78a3f}

# Clone ovs repo
git clone $OVS_REPO
cd ovs

if [[ "z$OVS_BRANCH" != "z" ]]; then
	git checkout $OVS_BRANCH
fi

# Compile the sources and install OVS
./boot.sh
./configure
make
sudo make install

OVS_DIR = $(pwd)
cd ..

OVN_REPO=${GIT_REPO:-https://github.com/ovn-org/ovn.git}
OVN_BRANCH=${GIT_BRANCH:-main}

# Clone ovN repo
git clone $OVN_REPO
cd ovN

if [[ "z$OVN_BRANCH" != "z" ]]; then
	git checkout $OVN_BRANCH
fi

# Compile the sources and install OVN
./boot.sh
./configure --with-ovs-source=$OVS_DIR
make
sudo make install

# Start both OVS and OVN services
sudo /usr/local/share/openvswitch/scripts/ovs-ctl start --system-id="ovn"
sudo /usr/local/share/ovn/scripts/ovn-ctl start_ovsdb --db-nb-create-insecure-remote=yes --db-sb-create-insecure-remote=yes
sudo /usr/local/share/ovn/scripts/ovn-ctl start_northd
sudo /usr/local/share/ovn/scripts/ovn-ctl start_controller

# Configure OVN in OVSDB
sudo ovs-vsctl set open . external-ids:ovn-bridge=br-int
sudo ovs-vsctl set open . external-ids:ovn-remote=unix:/usr/local/var/run/ovn/ovnsb_db.sock
sudo ovs-vsctl set open . external-ids:ovn-encap-ip=127.0.0.1
sudo ovs-vsctl set open . external-ids:ovn-encap-type=geneve
