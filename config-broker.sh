#!/bin/bash

INIT_DIR=$PWD
if [[ -z $BROKER_USER ]]; then
	BROKER_USER=user
fi

if [[ -z $BROKER_PASSWORD ]]; then
	BROKER_PASSWORD=broker_pass
fi

#Creating passwd file with provided variables
MOSQUITTO_CONFIG_FOLDER=$INIT_DIR/mosquitto
docker run -it --rm --name temp_mosquitto \
	-v $MOSQUITTO_CONFIG_FOLDER:/mosquitto/config \
	-w /mosquitto/config \
	eclipse-mosquitto:2 /bin/sh -c "mosquitto_passwd -b -c /mosquitto/config/passwd $BROKER_USER $BROKER_PASSWORD"

#docker run -d --name temp_mosquitto eclipse-mosquitto:2
#docker exec -it temp_mosquitto /bin/sh -c "mosquitto_passwd -b -c /mosquitto/config/passwd user broker_pass"
#docker cp temp_mosquitto:/mosquitto/config/passwd $MOSQUITTO_CONFIG_FOLDER/passwd
#docker rm temp_mosquitto

#Creating configuration for mqtt.json
TB_GW_CONFIG_FOLDER=$INIT_DIR/config
docker run -it --rm --name temp_python \
	-e BROKER_USER=$BROKER_USER \
	-e BROKER_PASSWORD=$BROKER_PASSWORD \
	-v "$PWD":/usr/src/app \
	-w /usr/src/app \
	python:alpine python generate-config.py

#By default the output file is mqtt.json
if [[ -f "mqtt.json" ]]; then
	mv -f mqtt.json $TB_GW_CONFIG_FOLDER/mqtt.json
else
	echo "Configuration file not generated"
	exit 1
fi
