#!/bin/bash
#test develop
# set hostname irrespective of LINUX DISTRO
# currently works for redhat, centos, ubuntu, amzn
distro=`cat /etc/*release | grep -i ^ID= | cut -d = -f 2 | tr -d '"'`
case $distro in
    rhel)
yum install -y bind-utils wget unzip
ipaddr=`ifconfig eth0 | grep -i inet | grep -v inet6 | awk '{ print $2 }'`
host_name=`nslookup $ipaddr | grep -w name | awk '{print $NF}' | sed "s/\.$//"`
hostname $host_name
hostname >/etc/hostname
echo 'preserve_hostname: true' >>/etc/cloud/cloud.cfg
        ;;
    centos)
        yum install -y bind-utils wget unzip
        ipaddr=`ifconfig eth0 | grep -i inet | grep -v inet6 | awk '{ print $2 }'`
        host_name=`nslookup $ipaddr | grep -i name | awk '{print $NF}' | sed "s/\.$//"`
        hostname $host_name
        hostname >/etc/hostname
        echo 'preserve_hostname: true' >>/etc/cloud/cloud.cfg
        ;;
    amzn)
        yum install -y bind-utils wget unzip
        ipaddr=`ifconfig eth0 | grep -i inet | grep -v inet6 | awk '{ print $2 }' | cut -d : -f 2`
        host_name=`nslookup $ipaddr | grep -i name | awk '{print $NF}' | sed "s/\.$//"`
        host_name_short=`echo $host_name | cut -d . -f 1`
        hostname $host_name
        sed -i "s/localhost.localdomain/$host_name/" /etc/sysconfig/network
        ;;
    ubuntu)
        apt-get install -y dnsutils wget unzip
        ipaddr=`ifconfig eth0 | grep -i inet | grep -v inet6 | awk '{ print $2 }' | cut -d : -f 2`
        host_name=`nslookup $ipaddr | grep -i name | awk '{print $NF}' | sed "s/\.$//"`
        host_name_short=`echo $host_name | cut -d . -f 1`
        hostname $host_name
        hostname >/etc/hostname
        sed -i 's/^preserve_hostname: false/preserve_hostname: true/' /etc/cloud/cloud.cfg
        ;;
    *)
        echo "unsupported  distro"
        ;;
esac
