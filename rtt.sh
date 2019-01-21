#!/bin/bash
if [ -d /data/rtt ];then
date +%s >>/data/rtt/time
else
mkdir -p /data/rtt/
date +%s >>/data/rtt/time
fi
a=`curl -s http://ipecho.net/plain;echo`
if  { ps auxwww|grep tshar[k] >/dev/null; } ; then
        echo exit
        exit
fi
killall -9 tshark
grep "end" /data/rtt/rtt.temp|awk -F " " '{print " " " " " "   }' >>/data/rtt/$a
tshark -i eth0 -n -R  "tcp.seq==1 && tcp.ack==1 && tcp.len==0 && (tcp.window_size_scalefactor!=-1)" -e frame.time_epoch -e tcp.analysis.ack_rtt -e ip.src -e ip.dst -T fields 2>/dev/null |awk '(NF==4){print "unixtime="$1,"rtt="$2,"ip_src="$3,"ip_dst="$4" end"} ' >/data/rtt/rtt.temp 2>/dev/null