#!/bin/sh

INTERFACE=$1
STATUS=$2

if [[ $CONNECTION_ID =~ "ethernet-single-host" ]]; then
  DHCP_CONFIG_FILE_LOCATION=/home/jdorel/documents/private_documents/computer_files/config/etc/dhcpd.conf/$CONNECTION_ID-dhcpd.conf
  DHCP_LEASES_FILE_LOCATION=/var/lib/dhcp/dhcpd-$CONNECTION_ID.leases
  DHCP_PID_FILE_LOCATION=/var/run/dhcpd-$CONNECTION_ID.pid

  if [[ $STATUS =~ "up" ]]; then
    # Start DHCP Server
    ## cf: configuration, lf: lease file, pf: pid file
    touch $DHCP_LEASES_FILE_LOCATION
    touch $DHCP_PID_FILE_LOCATION
    dhcpd \
      -cf $DHCP_CONFIG_FILE_LOCATION\
      -lf $DHCP_LEASES_FILE_LOCATION\
      -pf $DHCP_PID_FILE_LOCATION

    # Start NAT

  elif [[ $STATUS =~ "down" ]]; then
    # Stop DHCP Server
    ## Send SIGINT(2) signal
    kill -s INT $(cat $DHCP_PID_FILE_LOCATION) 
    # Clean DHCP server files
      rm $DHCP_LEASES_FILE_LOCATION
      rm $DHCP_PID_FILE_LOCATION

    # Stop NAT
  fi
fi
