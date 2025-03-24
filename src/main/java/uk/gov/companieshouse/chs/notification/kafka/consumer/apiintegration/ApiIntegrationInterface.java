package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkEmailDetailsRequest;

public interface ApiIntegrationInterface {

     void sendEmail(GovUkEmailDetailsRequest govUkEmailDetailsRequest);

     void sendLetter(GovUkLetterDetailsRequest govUkLetterRequest);
}
