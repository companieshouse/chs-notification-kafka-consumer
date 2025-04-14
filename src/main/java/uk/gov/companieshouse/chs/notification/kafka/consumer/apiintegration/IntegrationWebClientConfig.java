package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class IntegrationWebClientConfig {

    private final String internalApiUrl;
    private final String chsInternalApiKey;
    private final String notifyIntegrationApiBasePath;

    public IntegrationWebClientConfig(
            @Value("${chs.internal.api.key}") final String chsInternalApiKey,
            @Value("${internal.api.url}") final String internalApiUrl,
            @Value("${notify.integration.path:/gov-uk-notify-integration}") final String notifyIntegrationApiBasePath
    ) {
        this.chsInternalApiKey = chsInternalApiKey;
        this.internalApiUrl = internalApiUrl;
        this.notifyIntegrationApiBasePath = notifyIntegrationApiBasePath;
    }

    @Bean
    public WebClient integrationWebClient() {
        return WebClient.builder()
                .baseUrl(internalApiUrl + notifyIntegrationApiBasePath)
                .defaultHeader("Authorization", chsInternalApiKey)
                .build();
    }

}
