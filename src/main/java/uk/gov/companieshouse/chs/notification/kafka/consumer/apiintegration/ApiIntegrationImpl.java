package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;

import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

@Service
class ApiIntegrationImpl implements ApiIntegrationInterface {

    private final WebClient integrationWebClient;

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    public ApiIntegrationImpl(final WebClient integrationWebClient) {
        this.integrationWebClient = integrationWebClient;
    }

    @Override
    public void sendEmailMessageToIntegrationApi(final GovUkEmailDetailsRequest govUkEmailDetailsRequest,
                                                 final Runnable onSuccess) {
        integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/email")
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

    @Override
    public void sendLetterMessageToIntegrationApi(final GovUkLetterDetailsRequest govUkLetterDetailsRequest,
                                                  final Runnable onSuccess) {
        integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/letter")
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
