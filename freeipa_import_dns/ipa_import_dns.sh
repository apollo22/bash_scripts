#! /bin/bash

if [[ ! $# -eq 2 ]]; then
    echo "Usage: $0 <filename> <domain_name>"
    exit 1
fi

zone_name=$2
while read line; do
    if echo $line | grep "IN A" > /dev/null; then
        record_name=$( echo $line | awk '{print $1}' | sed s/.$zone_name.//)
        ip_address=$( echo $line | awk '{print $5}' )
        ipa dnsrecord-add $zone_name $record_name --a-ip-address=$ip_address
    fi
done < $1

while read line; do
    if echo $line | grep "IN CNAME" > /dev/null; then
        record_name=$( echo $line | awk '{print $1}' | sed s/.$zone_name.//)
        hostname=$( echo $line | awk '{print $5}' )
        # echo Record name : $record_name
        # echo Hostname : $hostname
        ipa dnsrecord-add $zone_name $record_name --cname-hostname=$hostname
    elif echo $line | grep "IN MX" > /dev/null; then
        record_name=$( echo $line | awk '{print $1}' | sed s/.$zone_name.//)
        preference=$( echo $line | awk '{print $5}' )
        exchanger=$( echo $line | awk '{print $6}' )
        # echo Record name : $record_name
        # echo Preference : $preference
        # echo Exchanger : $exchanger
        ipa dnsrecord-add $zone_name $record_name --mx-exchanger=$exchanger --mx-preference=$preference
    elif echo $line | grep "IN NS" > /dev/null; then
        record_name=$( echo $line | awk '{print $1}' )
        hostname=$( echo $line | awk '{print $5}' )
        # echo Record name : $record_name
        # echo Hostname : $hostname
        ipa dnsrecord-add $zone_name $record_name --ns-hostname=$hostname
    fi
done < $1
