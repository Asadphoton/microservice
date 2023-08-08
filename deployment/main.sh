#!/bin/bash

BDIR=`dirname $0`
cd $BDIR

if [ "$#" -ne 1 ]
then
	echo [Usage]
	echo main.sh {build_number}
	exit 1
fi

Deployment_Instance_IP=`aws ec2 describe-instances   --filter "Name=instance-state-name,Values=running"   --query "Reservations[*].Instances[*].[PublicIpAddress, Tags[?Key=='Name'].Value|[0]]"   --output text | grep -i 'Deployment_Instance' | awk '{print $1}'`

echo "Deployment Server Public IP - $Deployment_Instance_IP"

deploy()
{
	sed -i "s:host:${2}:g" etc/hosts
        set -x
	ansible-playbook --inventory-file="etc/hosts" ./main.yml --extra-vars build_number="$1"
        sed -i "s:${2}:host:g" etc/hosts
}

deploy $1 $Deployment_Instance_IP

echo "Application can be accessed at http://$Deployment_Instance_IP"
