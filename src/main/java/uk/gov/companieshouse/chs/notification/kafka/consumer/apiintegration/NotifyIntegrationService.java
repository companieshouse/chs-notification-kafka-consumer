package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import static com.google.common.net.HttpHeaders.X_REQUEST_ID;
import static uk.gov.companieshouse.chs.notification.kafka.consumer.ChsNotificationKafkaConsumerApplication.APPLICATION_NAMESPACE;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import java.util.Objects;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;
import uk.gov.companieshouse.logging.util.DataMap;

@Validated
@Service
public class NotifyIntegrationService {

    private final WebClient notifyIntegrationWebClient;
    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    public NotifyIntegrationService(final WebClient integrationWebClient) {
        this.notifyIntegrationWebClient = integrationWebClient;
    }

    public Mono<Void> sendEmailMessageToIntegrationApi(
            @NotNull @Valid final GovUkEmailDetailsRequest govUkEmailDetailsRequest,
            final String contextId) {

        return notifyIntegrationWebClient.post()
                .uri("/email")
                .header("Content-Type", "application/json")
                .header(X_REQUEST_ID, contextId)
                .bodyValue(govUkEmailDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .doOnError(WebClientResponseException.class, err -> {
                    var logMap = new DataMap.Builder()
                            .uri("/email")
                            .contextId(contextId)
                            .errorMessage(err.getMessage())
                            .status(Objects.toString(err.getStatusCode().value()))
                            .build().getLogMap();
                    LOG.error("Email API call failed", new Exception(err), logMap);
                })
                .then();
    }

    public Mono<Void> sendLetterMessageToIntegrationApi(
            @NotNull @Valid final GovUkLetterDetailsRequest govUkLetterDetailsRequest,
            final String contextId) {
        return notifyIntegrationWebClient.post()
                .uri("/letter")
                .header("Content-Type", "application/json")
                .header(X_REQUEST_ID, contextId)
                .bodyValue(govUkLetterDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .doOnError(WebClientResponseException.class, err -> {
                    var logMap = new DataMap.Builder()
                            .uri("/letter")
                            .contextId(contextId)
                            .message(err.getMessage())
                            .status(Objects.toString(err.getStatusCode().value()))
                            .build().getLogMap();
                    LOG.error("Letter API call failed", new Exception(err), logMap);
                })
                .then();
    }
}
