#!/bin/bash
: '
This script will return system information like:
Memory
Cpu
Disks
IPs
etc
'

#Check architecture
echo -e "Architecture : "  $(uname -m)
 
#Check the kernel release
echo -e "Kernel Release : " $(uname -r)
 
#Show hostname
echo -e "Hostname : " $HOSTNAME
 
#Show internal IP address
echo -e "Internal IP : " $(hostname -I)
 
#Show external IP address
echo -e "External IP : " $(curl -s https://ipinfo.io/ip)
 
#Show DNS
echo -e "Name servers : " $(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
 
#List logged in users
echo -e "Logged in users on system : " $(who > /tmp/who.txt; cat /tmp/who.txt)
 
#Show memory and swap usage
echo -e "Memmory usage : " $(free -h | grep -v + | grep -v Swap)
echo -e "Swap usage : " $(free -h | grep -v + | grep -v Mem)
 
#Top 10 CPU consumming processes
echo -e "Top 10 processes sorted by CPU usage : " $(ps -eo ppid,pid,user,cmd,%me
m,%cpu --sort=-%cpu | head)
 
#Show disk usage
echo -e "Disk usage is : " $(df -h | grep 'Filesystem\ | /dev/sda*') # For /dev/
 you need to check the exact name of your disks.
 
#System load average
echo -e " Load average : " $(top -n 1 -b | grep 'load average:' | awk '{print $1
0 $11 $12}')
 
#Show system uptime
echo -e "System uptime : " $(uptime | awk '{print $3, $4}' | cut -f1 -d ,)
