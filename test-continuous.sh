#!/bin/bash
# Based on entrypoint-mqtt.sh in plataforma-demos by Jorge Buzzio

#Variables for connection to broker
BROKER_HOST=localhost
BROKER_USER=user
BROKER_PASSWORD=broker_pass
BROKER_PORT=3883
DEVICE_NAME=SN-001

#Variables for magnitude variation
TEMP_BASE=30
HUM_BASE=60
TEMP_VAR=2
HUM_VAR=5
TIME=2

mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/$DEVICE_NAME/connect" -m '' -u $BROKER_USER -P $BROKER_PASSWORD

while [[ true ]]; do
        
        TEMP_VALUE=$(echo "scale=2; ${TEMP_BASE} + $(($RANDOM % (${TEMP_VAR}*100)))/100" | bc)
        HUM_VALUE=$(echo "scale=2; ${HUM_BASE} + $(($RANDOM % (${HUM_VAR}*100)))/100" | bc)

        mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "/sensor/$DEVICE_NAME/data" -m '{"temp": '$TEMP_VALUE', "hum": '$HUM_VALUE'}' -u $BROKER_USER -P $BROKER_PASSWORD

        echo "Temperatura: " $TEMP_VALUE " Humedad: " $HUM_VALUE
        sleep ${TIME}

done

mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT -t "sensor/$DEVICE_NAME/disconnect" -m '' -u $BROKER_USER -P $BROKER_PASSWORD
