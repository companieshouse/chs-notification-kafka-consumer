#!/bin/bash
#
# Start script for chs-notification-kafka-consumer

PORT=8080

exec java -jar -Dserver.port="${PORT}" "chs-notification-kafka-consumer.jar"
