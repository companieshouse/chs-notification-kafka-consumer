# chs-notification-kafka-consumer

## 1.0) Introduction

This module consumes kafka messages from the CHS Notification Kafka3 API module and sends a request to the Gov UK Notify integration module to send a letter or email.

The design for this module and the service it is a part of is here : https://companieshouse.atlassian.net/wiki/spaces/IDV/pages/5146247171/EMail+Service

## 2.0) Prerequisites

This Microservice has the following dependencies:

- [Java 21](https://www.oracle.com/java/technologies/downloads/#java21)
- [Maven](https://maven.apache.org/download.cgi)





# OWASP Dependency check

to run a check for dependency security vulnerabilities run the following command:

```shell
mvn dependency-check:check
```

# Endpoints

The remainder of this section lists the endpoints that are available in this microservice, and provides links to
detailed documentation about these endpoints e.g. required headers, path variables, query params, request bodies, and
their behaviour.

| Method | Path     | Description                                 | Documentation                                                                                                                                                                |
|--------|----------|---------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| GET    | http://127.0.0.1:9000/actuator/health | this endpoint is used to check that the service is running | |


