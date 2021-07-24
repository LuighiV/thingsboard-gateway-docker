#!/bin/bash

#BROKER_HOST=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tb-gateway-broker`
BROKER_HOST=localhost
BROKER_USER=user
BROKER_PASSWORD=broker_pass
BROKER_PORT=3883
DEVICE_NAME=SN-001

#one way
#mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/connect" -m '{"SerialNumber":"'$DEVICE_NAME'"}' -u $BROKER_USER -P $BROKER_PASSWORD
#
#mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "/sensor/data" -m '{"serialNumber":"'$DEVICE_NAME'", "temp": 32, "hum": 70}' -u $BROKER_USER -P $BROKER_PASSWORD
#
#mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/disconnect" -m '{"SerialNumber":"'$DEVICE_NAME'"}' -u $BROKER_USER -P $BROKER_PASSWORD

#another way
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/$DEVICE_NAME/connect" -m '' -u $BROKER_USER -P $BROKER_PASSWORD

mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "/sensor/$DEVICE_NAME/data" -m '{"temp": 32, "hum": 68}' -u $BROKER_USER -P $BROKER_PASSWORD

mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/$DEVICE_NAME/disconnect" -m '' -u $BROKER_USER -P $BROKER_PASSWORD
