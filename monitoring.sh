#!/bin/bash

{
echo "#Architecture: $(uname -a)"
echo "#CPU physical: $(cat /proc/cpuinfo | grep 'physical id'| uniq | wc -l)"
echo "#vCPU: $(cat /proc/cpuinfo | grep processor| wc -l)"
USED=$(free --mega | awk 'NR == 2 {print $3}')
TOTAL=$(free --mega | awk 'NR == 2 {print $2}')
PRCNT=$(free --mega | awk 'NR == 2 {printf "%.2f", $3*100/$2}')
echo "#Memory Usage: ${USED}/${TOTAL}MB (${PRCNT}%)"
USED=$(df -m --total | awk 'END {print $3}')
TOTAL=$(df -m --total | awk 'END {print $4}')
PRCNT=$(df -m --total | awk 'END {print $5}')
echo "#disk Usage: ${USED}/${TOTAL}MB (${PRCNT})"
echo "#CPU load: $(mpstat | awk '/all/ {printf "%.2f", 100 - $NF}')%"
echo "#Last boot: $(who -b | awk '{print $3, $4}')"
LVMCOUNT=$(/usr/sbin/blkid | grep -c '/dev/mapper')
if [ $LVMCOUNT -eq 0 ]
then
	echo "#LVM use: no"
else
	echo "#LVM use: yes"
fi
echo "#connections TCP: $(ss -s | awk '/TCP:/ {print $2}')"
echo "#User Log: $(who | wc -l)"
echo "#Network: IP $(hostname -I) ($(ip a | awk '/ether/ {print $2}'))"
echo "#Sudo: $(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l) cmd"
} | wall
