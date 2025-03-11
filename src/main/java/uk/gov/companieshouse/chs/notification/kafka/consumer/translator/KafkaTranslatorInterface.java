package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

/**
 * This public interface is used to translate kafka messages to GovUkRequest
 */
public interface KafkaTranslatorInterface {

    /**
     *
     *
     * @param emailMessage
     * @return
     */
     GovUkEmailDetailsRequest translateEmailKafkaMessage(final byte[] emailMessage );


    /**
     *
     *
     * @param letterMessage
     * @return
     */
    GovUkLetterDetailsRequest translateLetterKafkaMessage(final byte [] letterMessage );
}
