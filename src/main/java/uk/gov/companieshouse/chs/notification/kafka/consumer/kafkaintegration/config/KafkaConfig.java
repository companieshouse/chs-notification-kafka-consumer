package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration.config;

import java.util.HashMap;
import java.util.Map;

import consumer.deserialization.AvroDeserializer;
import consumer.serialization.AvroSerializer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.listener.ContainerProperties.AckMode;
import org.springframework.kafka.support.serializer.ErrorHandlingDeserializer;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Configuration
@EnableKafka
public class KafkaConfig {
    private final AvroDeserializer<ChsEmailNotification> emailDeserializer;
    private final AvroDeserializer<ChsLetterNotification> letterDeserializer;
    private final Map<String, Object> producerProps;
    private final Map<String, Object> consumerProps;

    @Autowired
    public KafkaConfig(AvroDeserializer<ChsEmailNotification> emailDeserializer,
                       AvroDeserializer<ChsLetterNotification> letterDeserializer,
                       @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {
        this.emailDeserializer = emailDeserializer;
        this.letterDeserializer = letterDeserializer;

        this.producerProps = new HashMap<>();
        producerProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        producerProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        producerProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, AvroSerializer.class);

        this.consumerProps = new HashMap<>();
        consumerProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        consumerProps.put(ErrorHandlingDeserializer.KEY_DESERIALIZER_CLASS, StringDeserializer.class);
        consumerProps.put(ErrorHandlingDeserializer.VALUE_DESERIALIZER_CLASS, AvroDeserializer.class);
        consumerProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        consumerProps.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        consumerProps.put(ConsumerConfig.ISOLATION_LEVEL_CONFIG, "read_committed");
        consumerProps.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 300000 );
        consumerProps.put(ConsumerConfig.MAX_POLL_INTERVAL_MS_CONFIG, 350000 );
        consumerProps.put(ConsumerConfig.HEARTBEAT_INTERVAL_MS_CONFIG, 5000 );

        /* SESSION_TIMEOUT_MS_CONFIG, MAX_POLL_INTERVAL_MS_CONFIG, HEARTBEAT_INTERVAL_MS_CONFIG
           These configs were added to alleviate a problem where the session was prematurely expiring.
           Premature expiration leads Kafka to believe to the consumer has failed when it hasn't. So it
           will incorrectly retry.

           We need to extract these into application.properties
        */


    }

    @Bean
    public KafkaTemplate<String, ChsEmailNotification> kafkaEmailTemplate() {
        return new KafkaTemplate<>(new DefaultKafkaProducerFactory<>(producerProps));
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChsEmailNotification> listenerContainerFactoryEmail() {
        ConcurrentKafkaListenerContainerFactory<String, ChsEmailNotification> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(new DefaultKafkaConsumerFactory<>(consumerProps, new StringDeserializer(), emailDeserializer));
        factory.getContainerProperties().setAckMode(AckMode.MANUAL_IMMEDIATE);
        return factory;
    }

    @Bean
    public KafkaTemplate<String, ChsLetterNotification> kafkaLetterTemplate() {
        return new KafkaTemplate<>(new DefaultKafkaProducerFactory<>(producerProps));
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChsLetterNotification> listenerContainerFactoryLetter() {
        ConcurrentKafkaListenerContainerFactory<String, ChsLetterNotification> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(new DefaultKafkaConsumerFactory<>(consumerProps, new StringDeserializer(), letterDeserializer));
        factory.getContainerProperties().setAckMode(AckMode.MANUAL_IMMEDIATE);
        return factory;
    }
}
