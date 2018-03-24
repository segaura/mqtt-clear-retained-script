#!/bin/sh

# based on the ideas in https://stackoverflow.com/questions/36729300/how-to-clear-all-retained-mqtt-messages-from-mosquitto

usage="Usage cleanmqtt -h <host> [-t <base-topic>] [-u user -p password]"
topic="#"
while getopts ":h:t:" opt; do
  case $opt in
    h)
#      echo "DEBUG: mqtt server hostname: " $OPTARG >&2
      host=$OPTARG
      ;;
    t)
#      echo "DEBUG: topic to clean: " $OPTARG >&2
      topic=$OPTARG"/#"
      ;;
    \?)
      echo "Invalid option: " -$OPTARG >&2
      echo $usage
      exit 1
      ;;
  esac
done

# check is $host is unset or empty
if [ -z $host ]; then echo "mandatory argument \"host\" not set"; echo $usage; exit 1; fi

echo "cleaning mqtt topic " $topic " at " $host
mosquitto_sub -h $host -t $topic -v | while read line _; do mosquitto_pub -h $host -t "$line" -r -n; done
