package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.kafka.support.Acknowledgment;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import static uk.gov.companieshouse.chs.notification.kafka.consumer.utils.StaticPropertyUtil.APPLICATION_NAMESPACE;

import uk.gov.companieshouse.logging.Logger;
import uk.gov.companieshouse.logging.LoggerFactory;


@Service
class ApiIntegrationImpl implements ApiIntegrationInterface {

    private final WebClient integrationWebClient;

    private static final Logger LOG = LoggerFactory.getLogger(APPLICATION_NAMESPACE);

    public ApiIntegrationImpl( final WebClient integrationWebClient) {
        this.integrationWebClient = integrationWebClient;
    }

    @Override
    public void sendEmailMessageToIntegrationApi(final GovUkEmailDetailsRequest govUkEmailDetailsRequest,
                                                 final Acknowledgment acknowledgment) {
        integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/email")
                .header("Content-Type", "application/json")
                .bodyValue(govUkEmailDetailsRequest)
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        LOG.info("Successfully sent email request to integration API, status: " + response.statusCode());
                        acknowledgment.acknowledge();
                        return Mono.empty();
                    } else {
                        LOG.error("Failed to send email request to integration API, status: " + response.statusCode());
                        return Mono.error(new RuntimeException("API call failed with status: " + response.statusCode()));
                    }
                })
                .onErrorResume(e -> {
                    LOG.error("Exception when sending email request to integration API: " + e.getMessage());
                    return Mono.empty();
                })
                .subscribe();
    }

    @Override
    public void sendLetterMessageToIntegrationApi(final GovUkLetterDetailsRequest govUkLetterDetailsRequest,
                                                  final Acknowledgment acknowledgment) {
        integrationWebClient.post()
                .uri("/chs-gov-uk-notify-integration-api/letter")
                .header("Content-Type", "application/json")
                .bodyValue(govUkLetterDetailsRequest)
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        LOG.info("Successfully sent letter request to integration API, status: " + response.statusCode());
                        acknowledgment.acknowledge();
                        return Mono.empty();
                    } else {
                        LOG.error("Failed to send letter request to integration API, status: " + response.statusCode());
                        return Mono.error(new RuntimeException("API call failed with status: " + response.statusCode()));
                    }
                })
                .onErrorResume(e -> {
                    LOG.error("Exception when sending letter request to integration API: " + e.getMessage());
                    return Mono.empty();
                })
                .subscribe();
    }
}

