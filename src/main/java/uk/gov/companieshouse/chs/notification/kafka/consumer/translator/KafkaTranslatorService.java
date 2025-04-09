package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import consumer.deserialization.AvroDeserializer;
import consumer.exception.NonRetryableErrorException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

@Service
class KafkaTranslatorService implements KafkaTranslatorInterface {

    private final String emailKafkaTopic;

    private final String letterKafkaTopic;

    private final AvroDeserializer<ChsEmailNotification> emailAvroDeserializer;
    private final AvroDeserializer<ChsLetterNotification> letterAvroDeserializer;

    private final MessageMapper messageMapper;

    private static final Logger LOGGER = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    public KafkaTranslatorService(@Value("${kafka.topic.email}") String emailTopic,
                                  @Value("${kafka.topic.letter}") String letterTopic,
                                  AvroDeserializer<ChsEmailNotification> emailAvroDeserializer,
                                  AvroDeserializer<ChsLetterNotification> letterAvroDeserializer,
                                  MessageMapper messageMapper) {
        this.emailKafkaTopic = emailTopic;
        this.letterKafkaTopic = letterTopic;
        this.emailAvroDeserializer = emailAvroDeserializer;
        this.letterAvroDeserializer = letterAvroDeserializer;
        this.messageMapper = messageMapper;
    }


    @Override
    public GovUkEmailDetailsRequest translateEmailKafkaMessage(final byte[] emailMessage) {
        try {
            LOGGER.info("about to convert to govuk email request");
            GovUkEmailDetailsRequest govUkEmailDetailsRequest = convertAvroToGovUkNotifyEmailRequest(emailMessage);
            LOGGER.info("successfully translated to govuk email request");
            return govUkEmailDetailsRequest;
        } catch (Exception ex) {
            LOGGER.error("Unable to deserialise emailMessage:", ex);
            throw new NonRetryableErrorException(
                    "Error deserialising chs-notification-email message", ex);
        }
    }

    @Override
    public GovUkLetterDetailsRequest translateLetterKafkaMessage(final byte[] letterMessage) {
        try {
            LOGGER.info("about to convert to govuk letter request");
            GovUkLetterDetailsRequest govUkLetterDetailsRequest = convertAvroToGovUkNotifyLetterRequest(letterMessage);
            LOGGER.info("successfully translated to govuk letter request");
            return govUkLetterDetailsRequest;
        } catch (Exception ex) {
            LOGGER.error("Unable to deserialise letterMessage:", ex);
            throw new NonRetryableErrorException(
                    "Error deserialising chs-notification-letter message", ex);
        }
    }

    private GovUkEmailDetailsRequest convertAvroToGovUkNotifyEmailRequest(final byte[] emailMessage) {
        final var chsEmailNotification = emailAvroDeserializer.deserialize(emailKafkaTopic, emailMessage);
        return messageMapper.mapToEmailDetailsRequest(chsEmailNotification);
    }

    private GovUkLetterDetailsRequest convertAvroToGovUkNotifyLetterRequest(final byte[] letterMessage) {
        final var chsLetterNotification = letterAvroDeserializer.deserialize(letterKafkaTopic, letterMessage);
        return messageMapper.mapToLetterDetailsRequest(chsLetterNotification);
    }

}
