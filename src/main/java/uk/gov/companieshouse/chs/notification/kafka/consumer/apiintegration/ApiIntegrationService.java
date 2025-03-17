package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Service;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

@Service
class ApiIntegrationService implements ApiIntegrationInterface{
    /**
     * @param govUkEmailDetailsRequest GovUkEmailDetailsRequest
     */
    @Override
    public void sendEmailMessageToIntegrationApi(GovUkEmailDetailsRequest govUkEmailDetailsRequest) {

    }

    /**
     * @param govUkLetterDetailsRequest GovUkLetterDetailsRequest
     */
    @Override
    public void sendLetterMessageToIntegrationApi(GovUkLetterDetailsRequest govUkLetterDetailsRequest) {

    }
}
