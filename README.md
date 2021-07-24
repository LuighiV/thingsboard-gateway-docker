# Scripts para desplegar Gateway de ThingsBoard

Contiene un conjunto de configuraciones predefinidas para facilitar el
despliegue del gateway mediante docker así como su integración con un broker de
MQTT.

El script principal es `deploy.sh` el cual genera los archivos de configuración
para el broker de MQTT y despliega los contenedores correspondientes al broker
y al gateway de ThingsBoard.

Este script acepta dos variables de entorno las cuales son:

| Variable        | Por defecto   |
| ----------------| ------------- |
| BROKER_USER     | user          |
| BROKER_PASSWORD | broker_pass   |

Estas variables se pueden definir de forma global o bien en línea con el
comando:
```
BROKER_USER=myuser BROKER_PASSWORD=mypass ./deploy.sh
```
