#! /bin/bash

sudo ovs-ofctl del-flows $1

sudo ovs-ofctl add-tlv-map $1 "{class=0xffff,type=0x80,len=4}->tun_metadata0"
sudo ovs-ofctl add-flow $1 "dl_type=0x0800, actions=set_field:10.0.0.2->tun_dst,set_field:10.0.0.1->tun_src,set_field:0xa->tun_metadata0,goto_table:1"
#resubmit(,1)
#sudo ovs-ofctl add-flow $1 in_port=2,dl_type=0x0800,nw_dst=10.0.0.1,actions=output:1
#sudo ovs-ofctl add-flow $1 'table=1, in_port=1,dl_type=0x0800,actions=push_tun_opt:0x1234abcd,output:2'
sudo ovs-ofctl add-flow $1 'table=1, tun_dst=10.0.0.2,actions=push_tun_opt:0x1234abcd,output:2'
#sudo ovs-ofctl add-flow $1 in_port=1,dl_type=0x0800,nw_dst=10.0.0.2,actions=output:2
#sudo ovs-ofctl add-flow $1 'in_port=1,dl_type=0x0800,nw_dst=10.0.0.2,actions=load:0x48ef->nw_id,output:2'
#sudo ovs-ofctl add-flow $1 'in_port=2,dl_type=0x806,actions=set_field:10.0.0.2->tun_dst,set_field:10.0.0.1->tun_src,set_field:0xa->tun_metadata0,output:1'
#sudo ovs-ofctl add-flow $1 'in_port=1,dl_type=0x806,actions=set_field:10.0.0.1->tun_dst,set_field:10.0.0.2->tun_src,set_field:0xa->tun_metadata0,output:2'
sudo ovs-ofctl add-flow $1 'in_port=2,dl_type=0x806,actions=output:1'
sudo ovs-ofctl add-flow $1 'in_port=1,dl_type=0x806,actions=output:2'
sudo ovs-ofctl dump-flows $1
