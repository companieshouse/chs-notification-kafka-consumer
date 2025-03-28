package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class IntegrationWebClientConfig {

    private final String internalApiUrl;
    private final String chsInternalApiKey;

    public IntegrationWebClientConfig(
            @Value("${internal.api.url}") String internalApiUrl,
            @Value("${chs.internal.api.key}") String chsInternalApiKey) {
        this.internalApiUrl = internalApiUrl;
        this.chsInternalApiKey = chsInternalApiKey;
    }

    @Bean
    public WebClient integrationWebClient() {
        return WebClient.builder()
                .baseUrl(internalApiUrl)
                .defaultHeader("Authorization", chsInternalApiKey)
                .build();
    }

}