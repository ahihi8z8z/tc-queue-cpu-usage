#! /bin/bash

sv_ip=$2


tc qdisc del dev h1-eth0 root
tc qdisc add dev h1-eth0 parent root handle 1: hfsc default 30
tc class add dev h1-eth0 parent 1: classid 1:1 hfsc sc rate 1000mbps ul rate 1000mbps
tc class add dev h1-eth0 parent 1:1 classid 1:30 hfsc sc rate 1kbps 
if [[ $3 -eq 1 ]]
then
	rate=$((1000/$1))
	for (( i=1; i<=$1; i++ ))
	do
	    port=$(($i + 1000))
	    tc class add dev h1-eth0 parent 1:1 classid "1:$port" hfsc sc rate ""$rate"mbps" ul rate 1000mbps
	    tc filter add dev h1-eth0 protocol ip parent 1: prio 1 u32 match ip dport "$port" 0xffff flowid "1:$port"
	    iperf -p "$port" -c "$sv_ip" -t 60 & 
	done
else
	for (( i=1; i<=$1; i++ ))
	do
	    port=$(($i + 1000))
	    iperf -p "$port" -c "$sv_ip" -t 60 & 
	done
fi

