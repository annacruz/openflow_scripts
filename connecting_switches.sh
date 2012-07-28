#!/bin/bash
ovs-vsctl add-port br0 patch1.2 -- set Interface patch1.2 type="patch" options:peer="patch2.1" ofport=3
ovs-vsctl add-port br1 patch2.1 -- set Interface patch2.1 type="patch" options:peer="patch1.2" ofport=3
