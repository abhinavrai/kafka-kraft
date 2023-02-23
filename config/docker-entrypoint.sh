#!/bin/ash

/srv/kafka/broker/bin/kafka-storage.sh format --config /srv/kafka/broker/config/server.properties --cluster-id '4tm2Pn1gRaaDZTJuUwbszw' --ignore-formatted

/srv/kafka/broker/bin/kafka-server-start.sh /srv/kafka/broker/config/server.properties
