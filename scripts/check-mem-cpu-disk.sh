#!/bin/bash
date
#cpu use threshold
cpu_load='5'
 #mem idle threshold
mem_threshold='100'
 #disk use threshold
disk_threshold='90'
#---cpu
cpu_usage () {
cpu_use_float=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')
cpu_use=$(echo "$cpu_use_float" | cut -d "." -f 1 | cut -d "," -f 1)
echo "cpu load: $cpu_use"
    if [[ "$cpu_use" -gt "$cpu_load" ]]
    then
        echo "cpu warning!!!"
        exit 1
    else
        echo "cpu ok!!!"
fi
}
#---mem
mem_usage () {
 #MB units
mem_free=$(free -m | grep "Mem" | awk '{print $4+$6}')
 echo "memory space remaining : $mem_free MB"
if [ "$mem_free" -lt $mem_threshold  ]
    then
        echo "mem warning!!!"
        exit 1
    else
        echo "mem ok!!!"
fi
}
#---disk
disk_usage () {
disk_use=$(df -P | grep /dev | grep -v -E '(tmp|boot)' | awk '{print $5}' | cut -f 1 -d "%")
 echo "disk usage : $disk_use%"
if [ "$disk_use" -gt $disk_threshold ]
    then
        echo "disk warning!!!"
        exit 1
    else
        echo "disk ok!!!"
fi


}
cpu_usage
mem_usage
disk_usage

