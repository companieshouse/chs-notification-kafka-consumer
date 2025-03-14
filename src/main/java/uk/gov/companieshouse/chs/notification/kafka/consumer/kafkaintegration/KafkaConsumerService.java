package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import consumer.exception.NonRetryableErrorException;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.RetryableTopic;
import org.springframework.kafka.retrytopic.DltStrategy;
import org.springframework.kafka.retrytopic.SameIntervalTopicReuseStrategy;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.retry.annotation.Backoff;
import org.springframework.stereotype.Service;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.ApiIntegrationInterface;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.KafkaTranslatorInterface;

@Service
public class KafkaConsumerService {

    private final KafkaTranslatorInterface kafkaTranslatorInterface;

    private final ApiIntegrationInterface apiIntegrationInterface;

    public KafkaConsumerService(KafkaTranslatorInterface kafkaTranslatorInterface, ApiIntegrationInterface apiIntegrationInterface) {
        this.kafkaTranslatorInterface = kafkaTranslatorInterface;
        this.apiIntegrationInterface = apiIntegrationInterface;
    }

    /**
     * Receives chs-notification-email topic messages <br>
     * retries on chs-notification-email-retry <br>
     * sends error messages to chs-notification-email-error
     */
    @RetryableTopic(attempts = "${kafka.max-attempts}",
            backoff = @Backoff(delayExpression = "${kafka.backoff-delay}"),
            sameIntervalTopicReuseStrategy = SameIntervalTopicReuseStrategy.SINGLE_TOPIC,
            dltTopicSuffix = "-error",
            dltStrategy = DltStrategy.FAIL_ON_ERROR,
            autoCreateTopics = "false",
            exclude = NonRetryableErrorException.class)
    @KafkaListener(topics = "${kafka.topic.email}",
            groupId = "${kafka.group-id.email}",
            containerFactory = "listenerContainerFactoryEmail")
    public void consumeEmailMessage(ConsumerRecord<String, byte[]> record, Acknowledgment acknowledgment) {
        if(record !=null && record.value() !=null && record.value().length !=0) {
            final var emailRequest = kafkaTranslatorInterface.translateEmailKafkaMessage(record.value());
            apiIntegrationInterface.sendEmailMessageToIntegrationApi(emailRequest);
            acknowledgment.acknowledge();
        } else {
            throw new IllegalArgumentException("Received null or empty Email message");
        }
    }

    /**
     * Receives chs-notification-letter topic messages. <br>
     * retries on chs-notification-letter-retry. <br>
     * sends error messages to chs-notification-email-error
     */
    @RetryableTopic(attempts = "${kafka.max-attempts}",
            backoff = @Backoff(delayExpression = "${kafka.backoff-delay}"),
            sameIntervalTopicReuseStrategy = SameIntervalTopicReuseStrategy.SINGLE_TOPIC,
            dltTopicSuffix = "-error",
            dltStrategy = DltStrategy.FAIL_ON_ERROR,
            autoCreateTopics = "false",
            exclude = NonRetryableErrorException.class)
    @KafkaListener(topics = "${kafka.topic.letter}",
            groupId = "${kafka.group-id.letter}",
            containerFactory = "listenerContainerFactoryLetter")
    public void consumeLetterMessage(ConsumerRecord<String, byte[]> record, Acknowledgment acknowledgment) {
        if(record !=null && record.value() !=null && record.value().length !=0) {
            final var letterRequest = kafkaTranslatorInterface.translateLetterKafkaMessage(record.value());
            apiIntegrationInterface.sendLetterMessageToIntegrationApi(letterRequest);
            acknowledgment.acknowledge();
        } else {
            throw new IllegalArgumentException("Received null or empty Letter message");
        }
    }
}
