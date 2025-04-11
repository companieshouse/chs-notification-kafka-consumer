package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

@Validated
@Service
public class NotifyIntegrationService {

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    private final WebClient notifyIntegrationWebClient;

    public NotifyIntegrationService(final WebClient integrationWebClient) {
        this.notifyIntegrationWebClient = integrationWebClient;
    }

    public Mono<Void> sendEmailMessageToIntegrationApi(@NotNull @Valid final GovUkEmailDetailsRequest govUkEmailDetailsRequest) {
        return notifyIntegrationWebClient.post()
                .uri("/email")
                .header("Content-Type", "application/json")
                .bodyValue(govUkEmailDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .then();
    }

    public Mono<Void> sendLetterMessageToIntegrationApi(@NotNull @Valid final GovUkLetterDetailsRequest govUkLetterDetailsRequest) {
        return notifyIntegrationWebClient.post()
                .uri("/letter")
                .header("Content-Type", "application/json")
                .bodyValue(govUkLetterDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .then();
    }
}
