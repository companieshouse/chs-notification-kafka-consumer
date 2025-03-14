package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

@Component
public interface ApiIntegrationInterface {
    void sendEmailMessageToIntegrationApi(GovUkEmailDetailsRequest govUkEmailDetailsRequest);
    void sendLetterMessageToIntegrationApi(GovUkLetterDetailsRequest govUkLetterDetailsRequest);
}
