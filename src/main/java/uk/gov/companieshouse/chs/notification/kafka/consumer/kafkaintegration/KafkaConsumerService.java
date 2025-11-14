package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import consumer.exception.NonRetryableErrorException;
import java.time.Duration;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.RetryableTopic;
import org.springframework.kafka.retrytopic.DltStrategy;
import org.springframework.kafka.retrytopic.RetryTopicHeaders;
import org.springframework.kafka.retrytopic.SameIntervalTopicReuseStrategy;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.retry.annotation.Backoff;
import org.springframework.stereotype.Service;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.NotifyIntegrationService;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.MessageMapper;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;
import uk.gov.companieshouse.logging.util.DataMap;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.ChsNotificationKafkaConsumerApplication.APPLICATION_NAMESPACE;

@Service
class KafkaConsumerService {

    @Value( "${kafka.max-attempts}" )
    private Integer kafkaMaxAttempts;

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    private final NotifyIntegrationService notifyIntegrationService;
    private final MessageMapper messageMapper;

    public KafkaConsumerService(
            final NotifyIntegrationService apiIntegrationInterface,
            final MessageMapper messageMapper
    ) {
        this.notifyIntegrationService = apiIntegrationInterface;
        this.messageMapper = messageMapper;
    }

    /**
     * Receives chs-notification-email topic messages <br> retries on chs-notification-email-retry
     * <br> sends error messages to chs-notification-email-error
     */
    @RetryableTopic(
            attempts = "${kafka.max-attempts}",
            backoff = @Backoff(delayExpression = "${kafka.backoff-delay}"),
            sameIntervalTopicReuseStrategy = SameIntervalTopicReuseStrategy.SINGLE_TOPIC,
            dltTopicSuffix = "-error",
            dltStrategy = DltStrategy.FAIL_ON_ERROR,
            autoCreateTopics = "false",
            exclude = NonRetryableErrorException.class,
            kafkaTemplate = "kafkaEmailTemplate"
    )
    @KafkaListener(
            topics = "${kafka.topic.email}",
            groupId = "${kafka.group-id.email}",
            containerFactory = "listenerContainerFactoryEmail"
    )
    public void consumeEmailMessage(
            final @Header( name = RetryTopicHeaders.DEFAULT_HEADER_ATTEMPTS, required = false ) Integer attemptNumber,
            ConsumerRecord<String, ChsEmailNotification> consumerRecord,
            Acknowledgment acknowledgment) {

        try {
            var logMapBuilder = new DataMap.Builder()
                    .topic(consumerRecord.topic())
                    .partition(consumerRecord.partition())
                    .offset(consumerRecord.offset())
                    .kafkaMessage(consumerRecord.value().toString());

            LOG.debug("Consuming email record: " + consumerRecord,
                    logMapBuilder.build().getLogMap());
            var emailNotification = consumerRecord.value();
            LOG.info("Consuming email record with sender reference: "
                            + emailNotification.getSenderDetails().getReference(),
                    logMapBuilder.build().getLogMap());

            final var emailRequest = messageMapper.mapToEmailDetailsRequest(emailNotification);
            notifyIntegrationService.sendEmailMessageToIntegrationApi(emailRequest)
                    .block(Duration.ofMinutes( 3L ));
        } catch ( Exception exception ){
            LOG.error( "Error encountered in Email Consumer: ", exception );
        } finally {
            acknowledgment.acknowledge();
        }
    }

    /**
     * Receives chs-notification-letter topic messages. <br> retries on
     * chs-notification-letter-retry. <br> sends error messages to chs-notification-email-error
     */
    @RetryableTopic(
            attempts = "${kafka.max-attempts}",
            backoff = @Backoff(delayExpression = "${kafka.backoff-delay}"),
            sameIntervalTopicReuseStrategy = SameIntervalTopicReuseStrategy.SINGLE_TOPIC,
            dltTopicSuffix = "-error",
            dltStrategy = DltStrategy.FAIL_ON_ERROR,
            autoCreateTopics = "false",
            exclude = NonRetryableErrorException.class,
            kafkaTemplate = "kafkaLetterTemplate"
    )
    @KafkaListener(
            topics = "${kafka.topic.letter}",
            groupId = "${kafka.group-id.letter}",
            containerFactory = "listenerContainerFactoryLetter"
    )
    public void consumeLetterMessage(
            final @Header( name = RetryTopicHeaders.DEFAULT_HEADER_ATTEMPTS, required = false ) Integer attemptNumber,
            ConsumerRecord<String, ChsLetterNotification> consumerRecord,
            Acknowledgment acknowledgment) {


        try {

            var logMapBuilder = new DataMap.Builder()
                    .topic(consumerRecord.topic())
                    .partition(consumerRecord.partition())
                    .offset(consumerRecord.offset())
                    .kafkaMessage(consumerRecord.value().toString());

            LOG.debug("Consuming letter record: " + consumerRecord,
                    logMapBuilder.build().getLogMap());
            var letterNotification = consumerRecord.value();
            LOG.info("Consuming letter record with sender reference: "
                            + letterNotification.getSenderDetails().getReference(),
                    logMapBuilder.build().getLogMap());
            final var letterRequest = messageMapper.mapToLetterDetailsRequest(letterNotification);
            notifyIntegrationService.sendLetterMessageToIntegrationApi(letterRequest)
                    .block( Duration.ofMinutes( 3L ) );

        } catch ( Exception exception ){
            LOG.error( "Error encountered in Letter Consumer: ", exception );
        } finally {
            acknowledgment.acknowledge();
        }

    }
}
