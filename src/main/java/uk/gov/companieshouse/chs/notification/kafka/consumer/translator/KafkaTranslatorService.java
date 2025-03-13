package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import consumer.deserialization.AvroDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Service
class KafkaTranslatorService implements KafkaTranslatorInterface {

    private final String emailKafkaTopic;

    private final String letterKafkaTopic;

    private final AvroDeserializer avroDeserializer;

    private final MessageMapper messageMapper;

    public KafkaTranslatorService(@Value("${kafka.topic.email}") String emailTopic, @Value("${kafka.topic.letter}") String letterTopic, AvroDeserializer avroDeserializer, MessageMapper messageMapper) {
        this.emailKafkaTopic = emailTopic;
        this.letterKafkaTopic = letterTopic;
        this.avroDeserializer = avroDeserializer;
        this.messageMapper = messageMapper;
    }


    @Override
    public GovUkEmailDetailsRequest translateEmailKafkaMessage(final byte[] emailMessage) {
       return  convertAvroToGovUkNotifyEmailRequest(emailMessage);
    }

    @Override
    public GovUkLetterDetailsRequest translateLetterKafkaMessage(final byte[] letterMessage) {
        return  convertAvroToGovUkNotifyLetterRequest(letterMessage);
    }

    private GovUkEmailDetailsRequest convertAvroToGovUkNotifyEmailRequest(final byte[] emailMessage) {
        final var chsEmailNotification = (ChsEmailNotification) avroDeserializer.deserialize(emailKafkaTopic, emailMessage);
            return messageMapper.mapToEmailDetailsRequest(chsEmailNotification);
    }

    private GovUkLetterDetailsRequest convertAvroToGovUkNotifyLetterRequest(final byte[] letterMessage) {
        final var chsLetterNotification = (ChsLetterNotification) avroDeserializer.deserialize(letterKafkaTopic, letterMessage);
        return messageMapper.mapToLetterDetailsRequest(chsLetterNotification);
    }

}
