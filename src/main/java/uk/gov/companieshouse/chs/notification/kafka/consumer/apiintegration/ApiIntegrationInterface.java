package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import jakarta.validation.constraints.NotNull;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

@Validated
@Component
public interface ApiIntegrationInterface {

     void sendEmailMessageToIntegrationApi(@NotNull GovUkEmailDetailsRequest govUkEmailDetailsRequest, @NotNull Acknowledgment acknowledgment);

     void sendLetterMessageToIntegrationApi(@NotNull GovUkLetterDetailsRequest govUkLetterRequest, @NotNull Acknowledgment acknowledgment);
}
