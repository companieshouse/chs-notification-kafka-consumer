package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;


@Service
class ApiIntegrationImpl implements ApiIntegrationInterface {

    private final WebClient integrationWebClient;

    public ApiIntegrationImpl( final WebClient integrationWebClient) {
        this.integrationWebClient = integrationWebClient;
    }

    public void sendEmailMessageToIntegrationApi(final GovUkEmailDetailsRequest govUkEmailDetailsRequest) {
         integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/email")
                .header("Content-Type", "application/json")
                .bodyValue(govUkEmailDetailsRequest)
                .retrieve()
                .bodyToMono( Void.class)
                .subscribe();
    }

    public void sendLetterMessageToIntegrationApi(final GovUkLetterDetailsRequest govUkLetterDetailsRequest) {
         integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/letter")
                .header("Content-Type", "application/json")
                .bodyValue(govUkLetterDetailsRequest)
                .retrieve()
                .bodyToMono( Void.class)
                .subscribe();
    }
}

