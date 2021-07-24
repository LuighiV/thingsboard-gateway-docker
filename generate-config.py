#!/bin/python

import json as json
import os

template=r'''
{
  "broker": {
    "name":"Default Local Broker",
    "host":"tb-gateway-broker",
    "port":1883,
    "clientId": "ThingsBoard_gateway",
    "security": {
      "type": "basic",
      "username": "user",
      "password": "broker_pass"
    }
  },
  "mapping": [
    {
      "topicFilter": "/sensor/data",
      "converter": {
        "type": "json",
        "deviceNameJsonExpression": "${serialNumber}",
        "deviceTypeJsonExpression": "${sensorType}",
        "timeout": 60000,
        "attributes": [
          {
            "type": "string",
            "key": "model",
            "value": "${sensorModel}"
          },
          {
            "type": "string",
            "key": "${sensorModel}",
            "value": "on"
          }
        ],
        "timeseries": [
          {
            "type": "double",
            "key": "temperature",
            "value": "${temp}"
          },
          {
            "type": "double",
            "key": "humidity",
            "value": "${hum}"
          }
        ]
      }
    },
    {
      "topicFilter": "/sensor/+/data",
      "converter": {
        "type": "json",
        "deviceNameTopicExpression": "(?<=sensor\/)(.*?)(?=\/data)",
        "deviceTypeTopicExpression": "default",
        "timeout": 60000,
        "attributes": [
          {
            "type": "string",
            "key": "model",
            "value": "${sensorModel}"
          }
        ],
        "timeseries": [
          {
            "type": "double",
            "key": "temperature",
            "value": "${temp}"
          },
          {
            "type": "double",
            "key": "humidity",
            "value": "${hum}"
          }
        ]
      }
    },
    {
      "topicFilter": "/custom/sensors/+",
      "converter": {
        "type": "custom",
        "extension": "CustomMqttUplinkConverter",
        "extension-config": {
            "temperatureBytes" : 2,
            "humidityBytes" :  2,
            "batteryLevelBytes" : 1
        }
      }
    }
  ],
  "connectRequests": [
    {
      "topicFilter": "sensor/connect",
      "deviceNameJsonExpression": "${SerialNumber}"
    },
    {
      "topicFilter": "sensor/+/connect",
      "deviceNameTopicExpression": "(?<=sensor\/)(.*?)(?=\/connect)"
    }
  ],
  "disconnectRequests": [
    {
      "topicFilter": "sensor/disconnect",
      "deviceNameJsonExpression": "${SerialNumber}"
    },
    {
      "topicFilter": "sensor/+/disconnect",
      "deviceNameTopicExpression": "(?<=sensor\/)(.*?)(?=\/disconnect)"
    }
  ],
  "attributeUpdates": [
    {
      "deviceNameFilter": "SmartMeter.*",
      "attributeFilter": "uploadFrequency",
      "topicExpression": "sensor/${deviceName}/${attributeKey}",
      "valueExpression": "{\"${attributeKey}\":\"${attributeValue}\"}"
    }
  ],
  "serverSideRpc": [
    {
      "deviceNameFilter": ".*",
      "methodFilter": "echo",
      "requestTopicExpression": "sensor/${deviceName}/request/${methodName}/${requestId}",
      "responseTopicExpression": "sensor/${deviceName}/response/${methodName}/${requestId}",
      "responseTimeout": 10000,
      "valueExpression": "${params}"
    },
    {
      "deviceNameFilter": ".*",
      "methodFilter": "no-reply",
      "requestTopicExpression": "sensor/${deviceName}/request/${methodName}/${requestId}",
      "valueExpression": "${params}"
    }
  ]
}

'''

if 'BROKER_USER' in os.environ:
    BROKER_USER = os.environ.get('BROKER_USER')
else:
    print(f'BROKER_USER variable not defined, using default value')
    BROKER_USER = "user"

if 'BROKER_PASSWORD' in os.environ:
    BROKER_PASSWORD = os.environ.get('BROKER_PASSWORD')
else:
    print(f'BROKER_PASSWORD variable not defined, using default value')
    BROKER_PASSWORD = "broker_pass"

if 'OUTPUT_FILENAME' in os.environ:
    OUTPUT_FILENAME = os.environ.get('OUTPUT_FILENAME')
else:
    print(f'OUTPUT_FILENAME variable not defined, using default value')
    OUTPUT_FILENAME = "mqtt.json"

obj = json.loads(template)
obj['broker']['security']['username']=BROKER_USER
obj['broker']['security']['password']=BROKER_PASSWORD

with open(OUTPUT_FILENAME, "w") as write_file:
    json.dump(obj, write_file, indent=4)
