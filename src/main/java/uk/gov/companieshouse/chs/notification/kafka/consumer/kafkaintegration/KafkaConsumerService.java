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
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

@Service
class KafkaConsumerService {

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

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
        LOG.info("Consuming email message");

        // TODO: don't acknowledge null or empty records, figure out WHY they are null, and prevent it from happening
        if (record == null) {
            LOG.info("Record is null, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        if (record.value() == null) {
            LOG.info("Record value is null, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        if (record.value().length == 0) {
            LOG.info("Record value is empty, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        LOG.info("Record is valid, and has data");
        final var emailRequest = kafkaTranslatorInterface.translateEmailKafkaMessage(record.value());
        LOG.info("Translated letter request");
        apiIntegrationInterface.sendEmailMessageToIntegrationApi(emailRequest, acknowledgment::acknowledge);
        LOG.info("Sent letter message to integration API");
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
        LOG.info("Consuming letter message");

        // TODO: don't acknowledge null or empty records, figure out WHY they are null, and prevent it from happening
        if (record == null) {
            LOG.info("Record is null, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        if (record.value() == null) {
            LOG.info("Record value is null, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        if (record.value().length == 0) {
            LOG.info("Record value is empty, acknowledging message");
            acknowledgment.acknowledge();
            return;
        }

        LOG.info("Record is valid, and has data");
        final var letterRequest = kafkaTranslatorInterface.translateLetterKafkaMessage(record.value());
        LOG.info("Translated letter request");
        apiIntegrationInterface.sendLetterMessageToIntegrationApi(letterRequest, acknowledgment::acknowledge);
        LOG.info("Sent letter message to integration API");
    }
}
