package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration.config;

import consumer.deserialization.AvroDeserializer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.listener.ContainerProperties;
import org.springframework.kafka.support.serializer.ErrorHandlingDeserializer;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableKafka
public class KafkaConfig {
    private final AvroDeserializer<ChsEmailNotification> emailNotificationAvroDeserializer;
    private final AvroDeserializer<ChsLetterNotification> letterNotificationAvroDeserializer;

    private final String bootstrapServers;

    @Autowired
    public KafkaConfig(AvroDeserializer<ChsEmailNotification> emailNotificationAvroDeserializer,
                       AvroDeserializer<ChsLetterNotification> letterNotificationAvroDeserializer,
                       @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {
        this.emailNotificationAvroDeserializer = emailNotificationAvroDeserializer;
        this.letterNotificationAvroDeserializer = letterNotificationAvroDeserializer;
        this.bootstrapServers = bootstrapServers;
    }

    /**
     * Email Kafka Consumer Factory.
     */
    @Bean
    public ConsumerFactory<String, ChsEmailNotification> kafkaEmailConsumerFactory() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigs(), new StringDeserializer(),
                new ErrorHandlingDeserializer<>(emailNotificationAvroDeserializer));
    }

    /**
     * Letter Kafka Consumer Factory.
     */
    @Bean
    public ConsumerFactory<String, ChsLetterNotification> kafkaLetterConsumerFactory() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigs(), new StringDeserializer(),
                new ErrorHandlingDeserializer<>(letterNotificationAvroDeserializer));
    }

    /**
     * Email Kafka Listener Container Factory.
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChsEmailNotification> listenerContainerFactoryEmail() {
        ConcurrentKafkaListenerContainerFactory<String, ChsEmailNotification> factory
                = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(kafkaEmailConsumerFactory());
        factory.getContainerProperties().setAckMode(ContainerProperties.AckMode.MANUAL);

        return factory;
    }

    /**
     * Letter Kafka Listener Container Factory.
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ChsLetterNotification> listenerContainerFactoryLetter() {
        ConcurrentKafkaListenerContainerFactory<String, ChsLetterNotification> factory
                = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(kafkaLetterConsumerFactory());
        factory.getContainerProperties().setAckMode(ContainerProperties.AckMode.MANUAL);

        return factory;
    }

    private Map<String, Object> consumerConfigs() {
        Map<String, Object> props = new HashMap<>();

        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);
        props.put(ErrorHandlingDeserializer.KEY_DESERIALIZER_CLASS, StringDeserializer.class);
        props.put(ErrorHandlingDeserializer.VALUE_DESERIALIZER_CLASS, AvroDeserializer.class);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        props.put(ConsumerConfig.ISOLATION_LEVEL_CONFIG, "read_committed");

        return props;
    }
}
