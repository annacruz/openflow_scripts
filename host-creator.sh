#!/bin/bash
#set -e

hostname=$1
ip=$2
switch=$3

sed -e "s/vim\,ssh/vim\,ssh\,tshark\,inetutils-ping\,intetutils-traceroute\,iperf/g" -i /usr/lib/lxc/templates/lxc-ubuntu

cat > /etc/lxc/lxc-ovs.conf << EOF
lxc.network.type=veth
lxc.network.script.up=/etc/lxc/ovsup
lxc.network.ipv4=11.0.0.$ip
lxc.network.flags=up
lxc.network.type=veth
lxc.network.link=lxcbr0
lxc.network.flags=up
EOF


cat > /etc/lxc/ovsup << EOF
#!/bin/bash

ifconfig \$5 0.0.0.0 up
ovs-vsctl add-port $switch \$5
EOF
chmod ugo+x /etc/lxc/ovsup

lxc-create -t ubuntu -n $hostname -f /etc/lxc/lxc-ovs.conf
#
# now on host do sudo ovs-vsctl add-port br0 gre0 -- set interface gre0 type=gre options:remote_ip=x.x.x.x
# where x.x.x.x is the public ip address of eth0 on the other ec2 node
