package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Service;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.KafkaTranslatorInterface;

@Service
public class ApiIntegrationService {

    private final KafkaTranslatorInterface kafkaMessageTranslator;

    ApiIntegrationService(KafkaTranslatorInterface kafkaMessageTranslator) {
        this.kafkaMessageTranslator = kafkaMessageTranslator;
    }

    public GovUkEmailDetailsRequest  translateEmailKafkaMessage(final byte[] emailMessage) {
       return kafkaMessageTranslator.translateEmailKafkaMessage(emailMessage);
    }

    public GovUkLetterDetailsRequest translateLetterKafkaMessage(final byte[] letterMessage ) {
        return kafkaMessageTranslator.translateLetterKafkaMessage(letterMessage);
    }
}
