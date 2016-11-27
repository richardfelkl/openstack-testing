#!/usr/bin/env bash

# NOTE: how to execute: source openrc && ./tempest_cleaner.sh CONTRAIL_IP

# TODO add openrc path to parameters and source it
mask='rally_\|tempest_\|ostf\|_snat_'

echo "Starting. Using mask '$mask'"
echo "Delete users"
for i in `openstack user list | grep $mask | awk '{print $2}'`; do openstack user delete $i; echo deleted $i; done
echo "Delete roles"
for i in `openstack role list | grep $mask | awk '{print $2}'`; do openstack role delete $i; echo deleted $i; done
echo "Delete servers"
for i in `openstack server list --all | grep $mask | awk '{print $2}'`; do openstack server delete $i; echo deleted $i; done
echo "Delete volumes"
for i in `openstack volume list --all | grep $mask | awk '{print $2}'`; do openstack volume delete $i; echo deleted $i; done
echo "Delete images"
for i in `openstack image list | grep $mask | awk '{print $2}'`; do openstack image delete $i; echo deleted $i; done
echo "Delete sec groups"
for i in `openstack security group list --all | grep $mask | awk '{print $2}'`; do openstack security group delete $i; echo deleted $i; done
echo "Delete keypairs"
for i in `openstack keypair list | grep $mask | awk '{print $2}'`; do openstack keypair delete $i; echo deleted $i; done
echo "Delete ports"
for i in `neutron port-list --all | grep $mask | awk '{print $2}'`; do neutron port-delete $i; done
echo "Delete routers"
for i in `neutron router-list --all | grep $mask | awk '{print $2}'`; do neutron router-delete $i; done
echo "Delete subnets"
for i in `neutron subnet-list --all | grep $mask | awk '{print $2}'`; do neutron subnet-delete $i; done
echo "Delete nets"
for i in `neutron net-list --all | grep $mask | awk '{print $2}'`; do neutron net-delete $i; done
echo "Delete projects"
for i in `openstack project list | grep $mask | awk '{print $2}'`; do openstack project delete $i; echo deleted $i; done
echo "Delete containers"
for i in `openstack container list --all | grep $mask | awk '{print $2}'`; do openstack container delete $i; echo deleted $i; done
echo "Done"

# todo contrail-api-cleaner //// add correct IP addresses
for j in access-control-list security-group service-instance instance-ip virtual-network virtual-machine-interface project routing-instance; do for i in `contrail-api-cli --os-auth-plugin v2password --host $1 --port 8082 --protocol http --insecure ls -l $j | grep tempest | awk '{print $1}'`; do contrail-api-cli --os-auth-plugin v2password --host $1 --port 8082 --protocol http --insecure rm -rf $i; done; done

