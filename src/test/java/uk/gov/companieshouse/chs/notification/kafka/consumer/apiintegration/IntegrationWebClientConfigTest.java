package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.web.reactive.function.client.WebClient;

@Tag( "unit-test" )
class IntegrationWebClientConfigTest {

    @Test
    void webClientIsCreatedCorrectly(){
        Assertions.assertTrue( WebClient.class.isAssignableFrom( new IntegrationWebClientConfig().integrationWebClient().getClass() ) );
    }

}
