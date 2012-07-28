insmod /home/lxc/openvswitch-1.6.1/datapath/linux/openvswitch_mod.ko
rm -r /usr/local/etc/openvswitch/conf.db
ovsdb-tool create /usr/local/etc/openvswitch/conf.db /home/lxc/openvswitch-1.6.1/vswitchd/vswitch.ovsschema
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --remote=db:Interface,ofport --pidfile --detach
#ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --private-key=db:SSL,private_key --certificate=db:SSL,certificate --bootstrap-ca-cert=db:SSL,ca_cert --pidfile --detach
ovs-vswitchd --pidfile --detach
ovs-vsctl add-br br0
#ovs-vsctl add-port br0 ovseth1
ovs-vsctl set-controller br0 tcp:$1
