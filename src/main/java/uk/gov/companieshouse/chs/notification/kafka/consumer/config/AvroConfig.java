package uk.gov.companieshouse.chs.notification.kafka.consumer.config;

import consumer.deserialization.AvroDeserializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Configuration
public class AvroConfig {

    @Bean
    public AvroDeserializer<ChsEmailNotification> emailAvroDeserializer() {
        return new AvroDeserializer<>(ChsEmailNotification.class);
    }

    @Bean
    public AvroDeserializer<ChsLetterNotification> letterAvroDeserializer() {
        return new AvroDeserializer<>(ChsLetterNotification.class);
    }

}
