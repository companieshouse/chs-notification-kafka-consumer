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
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.NotifyIntegrationService;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.MessageMapper;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

@Service
class KafkaConsumerService {

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    private final MessageMapper messageMapper;
    private final NotifyIntegrationService notifyIntegrationService;

    public KafkaConsumerService(MessageMapper messageMapper, NotifyIntegrationService apiIntegrationInterface) {
        this.messageMapper = messageMapper;
        this.notifyIntegrationService = apiIntegrationInterface;
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
    public void consumeEmailMessage(ConsumerRecord<String, ChsEmailNotification> consumerRecord, Acknowledgment acknowledgment) {
        LOG.info("Consuming email message");
        final var emailRequest = messageMapper.mapToEmailDetailsRequest(consumerRecord.value());
        notifyIntegrationService.sendEmailMessageToIntegrationApi(emailRequest, acknowledgment::acknowledge);
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
    public void consumeLetterMessage(ConsumerRecord<String, ChsLetterNotification> consumerRecord, Acknowledgment acknowledgment) {
        LOG.info("Consuming letter message");
        final var letterRequest = messageMapper.mapToLetterDetailsRequest(consumerRecord.value());
        notifyIntegrationService.sendLetterMessageToIntegrationApi(letterRequest, acknowledgment::acknowledge);
    }
}
