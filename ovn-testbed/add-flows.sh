#! /bin/bash

sudo ovs-ofctl del-flows test

sudo ovs-ofctl add-flow test in_port=2,dl_type=0x0800,nw_dst=10.1.1.2,actions=output:1
sudo ovs-ofctl add-flow test in_port=1,dl_type=0x0800,nw_id=0x49ef,actions=output:2
sudo ovs-ofctl add-flow test in_port=2,dl_type=0x806,nw_dst=10.1.1.2,actions=output:1
sudo ovs-ofctl add-flow test in_port=1,dl_type=0x806,nw_dst=10.1.1.3,actions=output:2

sudo ovs-ofctl dump-flows test
