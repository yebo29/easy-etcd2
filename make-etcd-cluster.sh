#!/bin/bash
CLUSTER_SIZE=${1:-1}
ETCD_HOST=${ETCD_HOST:-}
ETCD_CLUSTER=
for i in $(seq 1 $CLUSTER_SIZE); do
    echo Starting etcd container \#$i...
    if [[ "$FIRST_HOST" == "" ]]; then
    	CONTAINER=`docker run -d -e ETCD_HOST=$ETCD_HOST -p 2379:2379 --name etcd0$i miguelgrinberg/easy-etcd`
    else
	CONTAINER=`docker run -d -e ETCD_HOST=$ETCD_HOST --name etcd0$i miguelgrinberg/easy-etcd`
    fi
    IP_ADDRESS=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER`
    if [[ "$ETCD_CLUSTER" == "" ]]; then
        ETCD_CLUSTER=http://$IP_ADDRESS:2379
    else
    	ETCD_CLUSTER=$ETCD_CLUSTER,http://$IP_ADDRESS:2379
    fi
    sleep 5
    if [[ "$ETCD_HOST" == "" ]]; then
        ETCD_HOST=$IP_ADDRESS
    fi
    FIRST_HOST="no"
done
echo ETCDCTL_PEERS=$ETCD_CLUSTER
