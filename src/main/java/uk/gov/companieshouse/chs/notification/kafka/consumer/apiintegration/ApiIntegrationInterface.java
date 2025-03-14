package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;


public interface ApiIntegrationInterface {
    void sendEmailMessageToIntegrationApi(GovUkEmailDetailsRequest govUkEmailDetailsRequest);
    void sendLetterMessageToIntegrationApi(GovUkLetterDetailsRequest govUkLetterDetailsRequest);
}
