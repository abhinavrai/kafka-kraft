ARG CONTAINER_NAME
# Using OpenJDK JRE Headless 11.0.18_p10-r0

FROM strongestleo/openjdk11-jre-headless-alpine:11.0.18_p10-r0

ENV KAFKA_VERSION=3.4.0
ENV SCALA_VERSION=2.13

RUN ["apk", "add", "curl=7.88.1-r1"]
RUN ["apk", "add", "bash=5.2.15-r0"]

RUN ["mkdir", "-p", "/srv/kafka"]
RUN ["adduser", "-h", "/srv/kafka", "-D", "kafka"]

USER kafka
WORKDIR /srv/kafka

RUN ["mkdir", "-p", "/srv/kafka/broker"]
RUN ["mkdir", "-p", "/srv/kafka/data"]
RUN curl "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -o /tmp/kafka.tgz \
    && tar -zxf /tmp/kafka.tgz --directory /srv/kafka/broker --strip 1
RUN ["chmod", "-R", "u+x", "/srv/kafka/broker/bin"]

ARG CONTAINER_NAME

COPY --chown=kafka:kafka config/${CONTAINER_NAME}/server.properties /srv/kafka/broker/config/server.properties
COPY --chown=kafka:kafka config/log4j.properties /srv/kafka/broker/config/log4j.properties
COPY --chown=kafka:kafka config/start-kafka-kraft.sh /srv/kafka/start-kafka-kraft.sh
ENV PATH="$PATH:/srv/kafka/broker/bin"

RUN chmod +x  start-kafka-kraft.sh

CMD ["./start-kafka-kraft.sh"]
