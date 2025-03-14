package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

/**
 * This public interface is used to translate kafka messages to GovUkRequest
 */
@Component
public interface KafkaTranslatorInterface {

    /**
     *
     * @param emailMessage emailMessage
     * @return GovUkEmailDetailsRequest
     */
     GovUkEmailDetailsRequest translateEmailKafkaMessage(final byte[] emailMessage );


    /**
     *
     * @param letterMessage letterMessage
     * @return GovUkLetterDetailsRequest
     */
    GovUkLetterDetailsRequest translateLetterKafkaMessage(final byte [] letterMessage );
}
