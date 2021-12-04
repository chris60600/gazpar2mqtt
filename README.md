# gazpar2mqtt
Python script to fetch GRDF's website data and publish data to a mqtt broker

![Gazpar logo](https://s2.qwant.com/thumbr/474x266/d/6/5f73ca2a6a6ad456cee493bb73bc9bf24662ded76a98c4eb0a117e16d666d2/th.jpg?u=https%3A%2F%2Ftse2.explicit.bing.net%2Fth%3Fid%3DOIP.Y_lVygaMR2JQYgTvLVvc5wHaEK%26pid%3DApi&q=0&b=1&p=0&a=0)

![Grdf_website](https://s1.qwant.com/thumbr/0x0/2/7/5c8e1b6b4d304a208b062d1b4e113da7468170421d3f0a951f962de71ccb70/7d11f39a-a20c-4cf5-9510-bbb97d0d9cee.jpg?u=https%3A%2F%2Fmonespace.grdf.fr%2Fdocuments%2F20001%2F7d11f39a-a20c-4cf5-9510-bbb97d0d9cee&q=0&b=1&p=0&a=0)

![MQTT logo](https://s2.qwant.com/thumbr/474x266/e/b/0bb1caaf35b0ed78b567ce4ba21cffd3d22f8bc4a7c82a3ba331cc0dd88a23/th.jpg?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.eK8FAO1DnuuVt6wYA1WOmAHaEK%26pid%3DApi&q=0&b=1&p=0&a=0)

# Externals/Thanks
The project has been inspired by job done by [empierre](https://github.com/empierre/domoticz_gaspar) on project domoticz_gazpar and [beufanet](https://github.com/beufanet/gazpar) on project gazinflux availables on Github. I modified a bit the code to work and fit my needs.

# Informations

Important :
- The tool is still under development, various functions may disappear or be modified.
- GRDF website has a new design since 23/11/2021. We have redesign the app. A lot of work remains. All previous functionalities could not be performed.


## Changelogs :

- v0.5.x :
  - Hard redesign of the application after new GRDF website released on 23/11/2021 . Thanks to **echauvet** for his contribution.
  - Published values are now PCE dependent
  - Add last index
  - Home assistant : Add entity last index which can be integrated in Hass Energy panel
  - Rework of python code
  - Add Debug mode in environment variable
  - Add connexion retries to GRDF when it failed
- v0.4.x : 
  - Home assistant mqtt discovery available
  - Home assistant add-on available : https://github.com/alexbelgium/hassio-addons/tree/master/gazpar2mqtt (special thx to [alexbelgium](https://github.com/alexbelgium))
  - Enable Docker build for arm/v7 architecture
  - Enable MQTT SSL connexion
  - Grdf's thresholds (seuil) and previous year consumption
- v0.3.x :
  - First reliable release


## Roadmap :

- Calculation of monthly/weekly consumptions
- Provide an exemple of Home assistant card


# Requirements

## Python3 and libs

**python3** with its dependencies:

``` 
pip3 install -r app/requirement.txt
``` 

## GRDF Gazpar API

Verify you have gazpar data available on [GRDF Portal](https://monespace.grdf.fr/monespace/connexion)

For each PCE (Point de Comptage et d'Estimation) linked to GRDF account, data provided are :
- the previous day ~~and the current month consumptions~~ of gas (in m3) and energy (kwh)
- ~~the consumptions of the previous year for the current month~~
- ~~the threshold (seuil) of the current month defined in Grdf portal~~

Remember, kWh provided is conversion factor dependant. Please verify it's coherent with your provider bills.


## MQTT broker

A MQTT broker is required. Please check its configuration (hostname, port, remote access allowed, username & password if needed).


## Parameters

Currently, parameters can be provided by command's arguments or by the OS's environment variables.

Mandatory :

| Variable | Description |
| --- | --- |
| **GRDF_USERNAME** | Your GRDF login (ex : myemail@email.com) |
| **GRDF_PASSWORD** | Your GRDF password |
| **MQTT_HOST** | Hostname or ip adress of the MQTT broker |

Optionnal :

| Variable | Description | Default value |
| --- | --- | --- |
| **SCHEDULE_TIME** | Time for refreshing data everyday | None (format : 14:30) |
| **MQTT_PORT** | Port of the MQTT broker | 1883 |
| **MQTT_TOPIC** | Topic used as prefix | gazpar |
| **MQTT_CLIENTID** | Client id to be used for connexion to the MQTT broker | gazou |
| **MQTT_USERNAME** | Username to be used for connexion to the MQTT brokerr |  |
| **MQTT_PASSWORD** | Password to be used for connexion to the MQTT broker |  |
| **MQTT_QOS** | QOS for message publishing (0, 1 or 2) | 1 |
| **MQTT_RETAIN** | Retain flag| False |
| **MQTT_SSL** | Enable MQTT SSL connexion | False |
| **STANDALONE_MODE** | Enable standalone publication mode | True |
| **HASS_DISCOVERY** | Enable Home assistant dicovery mode | False |
| **HASS_PREFIX** | Home assistant topic prefix | homeassistant |
| **HASS_DEVICE_NAME** | Home assistant device name | gazpar |
| **DEBUG** | Enable debug mode| False |


# Usage

## Running script

Run it manually :

``` 
python3 app/gazpar2mqtt.py
``` 

Run it manually with a selection of arguments overwritting parameters :

``` 
python3 app/gazpar2mqtt.py --grdf_username=myemail@email.com --grdf_password=mypassword --mqtt_host=myhost --mqtt_clientId=gazou --mqtt_retain=True
``` 

Schedule it manually :

``` 
python3 app/gazpar2mqtt.py --schedule 10:30
``` 

Full list of arguments  :

``` 
python3 app/gazpar2mqtt.py --help
``` 



## Docker

![docker_logo](https://s1.qwant.com/thumbr/0x0/2/d/05170a4d28c2e2d0c394367d6db2e6f73292e9fbc305c087b51ee8b689e257/120px-Docker_(container_engine)_logo.png?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Farchive%2F7%2F79%2F20140516082115!Docker_(container_engine)_logo.png%2F120px-Docker_(container_engine)_logo.png&q=0&b=1&p=0&a=0)

Have a look the [docker repository](https://hub.docker.com/r/yukulehe/gazpar2mqtt) 

Example of docker run command with environment variables :

``` 
docker run --name app/gazpar2mqtt -e GRDF_USERNAME=gazou@email.com -e GRDF_PASSWORD=password -e MQTT_HOST=192.168.1.99 -e MQTT_PORT=1883 -e MQTT_CLIENTID=gazou -e MQTT_QOS=1 -e MQTT_TOPIC=gazpar -e MQTT_RETAIN=False --tty yukulehe/gazpar2mqtt:latest
```


## Standalone mode

Default mode, gazpar2mqtt is autonomous and is not dependent of any third-party tool.
Please note that only GRDF's **last values** are published in the MQTT broker in the topics bellow.
You can replace the default topic prefix *gazpar* (see mqtt broker requirements chapter)

### Measures :

| Topic | Description |
| --- | --- |
| gazpar/PCE/index | Index in cube meter of the last measure |
| gazpar/PCE/daily/date | Date of the last measure |
| gazpar/PCE/daily/kwh | Consumption in kwh of the last measure |
| gazpar/PCE/daily/mcube | Consumption in cube meter of the last measure  |

### Status :

| Topic | Description |
| --- | --- |
| gazpar/PCE/status/date | Last execution date time of gazpar2mqtt |
| gazpar/PCE/status/value | Last execution status of  gazpar2mqtt (ON or OFF) |


## Home Assistant discovery mode

![HA_logo](https://user-images.githubusercontent.com/31646663/141127001-6f868a1a-1820-45bc-9f3b-c3ee2a4d2d06.png)

Gazpar2mqtt provides Home Assistant compatible Mqtt devices. The discovery function enable to use MQTT devices with a minimal configuration effort.
Have a look to [Home Assistant Mqtt discovery documentation](https://www.home-assistant.io/docs/mqtt/discovery/).

### Device :
| Device name | Device ID | Model | Manufacturer |
| --- | --- | --- | --- |
| gazpar | gazpar_PCE | PCE | GRDF |

Note : you can replace the default device name *gazpar* by editing the related parameter.

### List of available sensors :

| Sensor name | Component | Device class | Description |
| --- | --- | --- | --- |
| gazpar_PCE_index | Sensor | Gas | Gas index in m3 of the last measure |
| gazpar_PCE_daily_gas | Sensor | Gas | Gas consumption in m3 of the last measure |
| gazpar_PCE_daily_energy | Sensor | Energy | Gas consumption in kWh of the last measure |
| gazpar_PCE_consumption_date | Sensor | Date | Date of the last measure |
| gazpar_PCE_connectivity | Binary sensor | Connectivity | Binary sensor which indicates if the last gazpar statement succeeded (ON) or failed (OFF) |


### List of topics :
| Topic | Description
| --- | --- 
| homeassistant/sensor/gazpar_PCE/config | Sensor's configuration topic |
| homeassistant/sensor/gazpar_PCE/state | Sensor's state topic |
| homeassistant/binary_sensor/gazpar_PCE/config | Binary sensor's configuration topic |
| homeassistant/binary_sensor/gazpar_PCE/state | Binary sensor's state topic |

Note : you can replace the default topic prefix *homeasssistant* by editing the related parameter.


### Add-on
For Hass.io users, gazpar2mqtt is also available as an add-on provided by [alexbelgium](https://github.com/alexbelgium) (thanks you to him). Please visit the dedicated [repository](https://github.com/alexbelgium/hassio-addons/tree/master/gazpar2mqtt).
