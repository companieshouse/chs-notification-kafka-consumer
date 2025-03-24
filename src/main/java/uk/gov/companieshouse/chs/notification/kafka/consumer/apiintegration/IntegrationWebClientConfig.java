package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class IntegrationWebClientConfig {

    @Value( "${internal.api.url}" )
    private String internalApiUrl;

    @Value( "${chs.internal.api.key}" )
    private String chsInternalApiKey;

    @Bean
    public WebClient integrationWebClient(){
        return WebClient.builder()
                .baseUrl( internalApiUrl )
                .defaultHeader( "Authorization", chsInternalApiKey )
                .build();
    }

}
