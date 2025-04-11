package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

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

    public void sendEmailMessageToIntegrationApi(@NotNull final GovUkEmailDetailsRequest govUkEmailDetailsRequest,
                                                 @NotNull final Runnable onSuccess) {
        notifyIntegrationWebClient.post()
                .uri("/email")
                .header("Content-Type", "application/json")
                .bodyValue(govUkEmailDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .doOnSuccess(response -> {
                    LOG.info("Successfully sent email request to integration API");
                    onSuccess.run();
                })
                .onErrorResume(e -> {
                    LOG.error("Failed to send email request to integration API: " + e.getMessage());
                    return Mono.empty();
                })
                .subscribe();
    }

    public void sendLetterMessageToIntegrationApi(@NotNull final GovUkLetterDetailsRequest govUkLetterDetailsRequest,
                                                  @NotNull final Runnable onSuccess) {
        notifyIntegrationWebClient.post()
                .uri("/letter")
                .header("Content-Type", "application/json")
                .bodyValue(govUkLetterDetailsRequest)
                .retrieve()
                .toBodilessEntity()
                .doOnSuccess(response -> {
                    LOG.info("Successfully sent letter request to integration API");
                    onSuccess.run();
                })
                .onErrorResume(e -> {
                    LOG.error("Failed to send letter request to integration API: " + e.getMessage());
                    return Mono.empty();
                })
                .subscribe();
    }
}
