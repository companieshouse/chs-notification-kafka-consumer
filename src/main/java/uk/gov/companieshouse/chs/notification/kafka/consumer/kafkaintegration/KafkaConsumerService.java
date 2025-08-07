package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import consumer.exception.NonRetryableErrorException;
import java.util.Map;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.RetryableTopic;
import org.springframework.kafka.retrytopic.DltStrategy;
import org.springframework.kafka.retrytopic.SameIntervalTopicReuseStrategy;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.retry.annotation.Backoff;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;
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
    public void consumeEmailMessage(ConsumerRecord<String, ChsEmailNotification> consumerRecord,
            Acknowledgment acknowledgment) {
        var logMapBuilder = new DataMap.Builder()
                .topic(consumerRecord.topic())
                .partition(consumerRecord.partition())
                .offset(consumerRecord.offset())
                .kafkaMessage(consumerRecord.value().toString());

        LOG.debug("Consuming email record: " + consumerRecord, logMapBuilder.build().getLogMap());
        var emailNotification = consumerRecord.value();
        LOG.info("Consuming email record with sender reference: "
                        + emailNotification.getSenderDetails().getReference(),
                logMapBuilder.build().getLogMap());

        final var emailRequest = messageMapper.mapToEmailDetailsRequest(emailNotification);
        notifyIntegrationService.sendEmailMessageToIntegrationApi(emailRequest)
                .doOnSuccess(v -> acknowledgment.acknowledge())
                .onErrorResume(e -> {
                    if (e instanceof WebClientResponseException) {
                        return Mono.error(e);
                    }
                    
                    var logMap = logMapBuilder
                            .errorMessage(e.getMessage())
                            .build()
                            .getLogMap();

                    LOG.error("Failed to send email request to integration API",
                            new Exception(e),
                            logMap
                    );
                    return Mono.error(e);
                })
                .block();
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
    public void consumeLetterMessage(ConsumerRecord<String, ChsLetterNotification> consumerRecord,
            Acknowledgment acknowledgment) {
        var logMapBuilder = new DataMap.Builder()
                .topic(consumerRecord.topic())
                .partition(consumerRecord.partition())
                .offset(consumerRecord.offset())
                .kafkaMessage(consumerRecord.value().toString());

        LOG.debug("Consuming letter record: " + consumerRecord, logMapBuilder.build().getLogMap());
        var letterNotification = consumerRecord.value();
        LOG.info("Consuming letter record with sender reference: "
                        + letterNotification.getSenderDetails().getReference(),
                logMapBuilder.build().getLogMap());
        final var letterRequest = messageMapper.mapToLetterDetailsRequest(letterNotification);
        notifyIntegrationService.sendLetterMessageToIntegrationApi(letterRequest)
                .doOnSuccess(v -> acknowledgment.acknowledge())
                .onErrorResume(e -> {
                    if (e instanceof WebClientResponseException) {
                        return Mono.error(e);
                    }

                    Map<String, Object> logMap = logMapBuilder
                            .errorMessage(e.getMessage())
                            .build()
                            .getLogMap();
                    LOG.error("Failed to send letter request to integration API",
                            new Exception(e),
                            logMap
                    );
                    return Mono.error(e);
                })
                .block();
    }
}
