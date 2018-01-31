#!/bin/bash

url="ya.ru"
port=443
logfile=netdiag$(date +"%d%w%k%M%S").log

comlist=(
"date +"%d/%m/%Y_%T""
"hostname"
"uname -a"
"host ${1:-$url}"
"nc -zv4 -w 30 ${1:-$url} ${2:-$port}"
"nc -zv6 -w 30 ${1:-$url} ${2:-$port}"
"ifconfig -a"
"netstat -rn"
"netstat -6 -rn"
"ping -c 10 ${1:-$url}"
"ping6 -c 10 ${1:-$url}"
"tracepath -b -m 18 ${1:-$url}"
"tracepath6 -b -m18 ${1:-$url}"
)

for ((i = 0; i < ${#comlist[@]}; i++)); do
        echo -e "<{${comlist[i]} \n%%" >> $logfile
        ${comlist[i]} >> $logfile 2>&1
        echo -e "%%\n}>" >> $logfile
        echo -ne "Progress.....$((${i}*100/${#comlist[@]}))%\r"
done

echo -ne "\n"
echo "All done, log here: $(pwd)/$logfile"

exit 0