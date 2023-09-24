### Measure CPu usage of egress traffic shaping (tc qdisc htb and hfsc)
- Run mininet with 2 host
```
sudo mn --custom=custom.py --topo mytopo,2
```
- In host 2, run iperf server:
```
./server.sh 100
# 100 is number of listening port
```
- In host 1, run iperf client:
```
./client.sh 100 10.0.0.2 1
# 100 is number of ports which server is listening
# 10.0.0.2 is server's ip
# 1 is turnning on tc hfsc queue to shaping traffic. Changing to 0 if you want to turn off tc hfsc queue . 
```
- Logging CPU total CPU usage every 1 second:
```
mpstat 1 > cpu.log 
``` 


# tc-queue-cpu-usage
