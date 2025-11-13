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
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.NotifyIntegrationService;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.MessageMapper;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;
import java.util.UUID;

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
    public void consumeEmailMessage( final @Header( name = RetryTopicHeaders.DEFAULT_HEADER_ATTEMPTS, required = false ) Integer attemptNumber, final ConsumerRecord<String, ChsEmailNotification> consumerRecord, final Acknowledgment acknowledgment ) {
        final var xRequestId = UUID.randomUUID().toString().substring( 0, 32 );
        try {
            final var emailNotification = consumerRecord.value();
            LOG.infoContext( xRequestId, String.format( "Email consumer received message. Topic: %s, Partition: %d, Offset: %d, Reference: %s, Payload: %s", consumerRecord.topic(), consumerRecord.partition(), consumerRecord.offset(), emailNotification.getSenderDetails().getReference(), consumerRecord.value().toString() ), null );

            Mono.just( emailNotification )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Attempting to map email", null ) )
                    .map( messageMapper::mapToEmailDetailsRequest )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Attempting to send email", null ) )
                    .flatMap( notifyIntegrationService::sendEmailMessageToIntegrationApi )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Successfully sent email", null ) )
                    .block(Duration.ofSeconds(20L));

            acknowledgment.acknowledge();
            LOG.infoContext( xRequestId, "Acknowledged", null );
        } catch ( Exception exception ){
            LOG.errorContext( xRequestId, exception, null );
            if ( kafkaMaxAttempts.equals( attemptNumber ) ){
                acknowledgment.acknowledge();
                LOG.infoContext( xRequestId, "Acknowledged", null );
            }
            LOG.error( "Error encountered in Email Consumer: ", exception );
            throw exception;
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
    public void consumeLetterMessage( final @Header( name = RetryTopicHeaders.DEFAULT_HEADER_ATTEMPTS, required = false ) Integer attemptNumber, final ConsumerRecord<String, ChsLetterNotification> consumerRecord, final Acknowledgment acknowledgment ) {
        final var xRequestId = UUID.randomUUID().toString().substring( 0, 32 );
        try {
            final var letterNotification = consumerRecord.value();
            LOG.infoContext( xRequestId, String.format( "Letter consumer received message. Topic: %s, Partition: %d, Offset: %d, Reference: %s, Payload: %s", consumerRecord.topic(), consumerRecord.partition(), consumerRecord.offset(), letterNotification.getSenderDetails().getReference(), consumerRecord.value().toString() ), null );

            Mono.just( letterNotification )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Attempting to map letter", null ) )
                    .map( messageMapper::mapToLetterDetailsRequest )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Attempting to send letter", null ) )
                    .flatMap( notifyIntegrationService::sendLetterMessageToIntegrationApi )
                    .doOnNext( letter -> LOG.debugContext( xRequestId, "Successfully sent letter", null ) )
                    .block( Duration.ofSeconds( 20L ) );

            acknowledgment.acknowledge();
            LOG.infoContext( xRequestId, "Acknowledged", null );
        } catch ( Exception exception ){
            LOG.errorContext( xRequestId, exception, null );
            if ( kafkaMaxAttempts.equals( attemptNumber ) ){
                acknowledgment.acknowledge();
                LOG.infoContext( xRequestId, "Acknowledged", null );
            }
            throw exception;
        }

    }
}
