#!/bin/bash

INIT_DIR=$PWD
if [[ -z $BROKER_USER ]]; then
	echo "Broker user not provided, using default"
	export BROKER_USER=user
fi

if [[ -z $BROKER_PASSWORD ]]; then
	echo "Broker pasword not provided, using default"
	export BROKER_PASSWORD=broker_pass
fi

./config-broker.sh
docker-compose up -d
