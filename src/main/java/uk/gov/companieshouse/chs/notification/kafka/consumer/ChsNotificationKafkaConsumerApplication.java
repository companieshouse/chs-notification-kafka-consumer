package uk.gov.companieshouse.chs.notification.kafka.consumer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ChsNotificationKafkaConsumerApplication {

    public static final String APPLICATION_NAMESPACE = "chs-notification-kafka-consumer";

    public static void main(String[] args) {
        SpringApplication.run(ChsNotificationKafkaConsumerApplication.class, args);
    }

    static {
        System.setProperty("org.apache.avro.SERIALIZABLE_PACKAGES", "*");
//        System.setProperty("org.apache.avro.SERIALIZABLE_PACKAGES", "uk.gov.companieshouse.*, consumer.*, accounts.*, email.*, monitor.*, payments.*, java.*, org.apache.avro.*, org.apache.kafka.*");
    }
}
