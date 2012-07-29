#!/bin/bash
#Script com fins de criar um set de switches (quantidade de switches definida do 1o parametro) relacionado a um unico controlador (ip do controlador definido no 2o parametro)

insmod /home/lxc/openvswitch-1.6.1/datapath/linux/openvswitch_mod.ko
rm -r /usr/local/etc/openvswitch/conf.db
ovsdb-tool create /usr/local/etc/openvswitch/conf.db /home/lxc/openvswitch-1.6.1/vswitchd/vswitch.ovsschema
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --remote=db:Interface,ofport --pidfile --detach
#ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --private-key=db:SSL,private_key --certificate=db:SSL,certificate --bootstrap-ca-cert=db:SSL,ca_cert --pidfile --detach
ovs-vswitchd --pidfile --detach

#Espero que ngm crie mais de 100 switches...
for ((i=0; i<$1; i++))
do
	ovs-vsctl add-br br$i
	ovs-vsctl set-controller br$i tcp:$2
	dpid=`echo $[$i+1]`
	if (( $dpid < "10" ))
	then
		dpid=0$dpid
	fi
	ovs-vsctl set Bridge br$i other_config:hwaddr="00:00:00:00:00:$dpid"
done
