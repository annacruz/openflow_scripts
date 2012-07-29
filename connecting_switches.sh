#!/bin/bash

switch1=$1
switch2=$2
cablename1=patch$1.$2
cablename2=patch$2.$1


ovs-vsctl add-port $switch1 $cablename1 -- set Interface $cablename1 type="patch" options:peer=$cablename2
ovs-vsctl add-port $switch2 $cablename2 -- set Interface $cablename2 type="patch" options:peer=$cablename1

porta1=`ovs-vsctl get Interface $cablename1 ofport`
porta2=`ovs-vsctl get Interface $cablename2 ofport`
echo ID da porta $cablename1: $porta1
echo ID da porta $cablename2: $porta2
