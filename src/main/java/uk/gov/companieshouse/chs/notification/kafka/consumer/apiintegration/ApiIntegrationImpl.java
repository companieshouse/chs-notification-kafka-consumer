package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkLetterDetailsRequest;

import java.time.Duration;

// URL Phoneix
// API key from postman
// flapdoodle - have a look at this. - only database.


@Service
class ApiIntegrationImpl implements ApiIntegrationInterface {

    private final WebClient integrationWebClient;

    public ApiIntegrationImpl( final WebClient integrationWebClient) {
        this.integrationWebClient = integrationWebClient;
    }

    public void sendEmail( final GovUkEmailDetailsRequest govUkEmailDetailsRequest) {
         integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/email")
                .header("Content-Type", "application/json")
                .bodyValue(govUkEmailDetailsRequest)
                .retrieve()
                .bodyToMono( Void.class)
                .subscribe();
    }

    public void sendLetter( final GovUkLetterDetailsRequest govUkLetterDetailsRequest) {
         integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/letter")
                .header("Content-Type", "application/json")
                .bodyValue(govUkLetterDetailsRequest)
                .retrieve()
                .bodyToMono( Void.class)
                .subscribe();
    }
}

