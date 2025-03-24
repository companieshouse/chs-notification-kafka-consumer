package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.GovUkLetterDetailsRequest;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
public class ApiIntegrationImplTest {

    @Mock
    private WebClient integrationWebClient;

    private WebClient.RequestBodyUriSpec requestBodyUriSpec;

    private WebClient.RequestBodySpec requestBodySpec;

    private WebClient.RequestHeadersSpec requestHeadersSpec;

    private WebClient.ResponseSpec responseSpec;

    @InjectMocks
    private ApiIntegrationImpl apiIntegrationImpl;

    @BeforeEach
    public void setUp() {
        when(integrationWebClient.post()).thenReturn(requestBodyUriSpec);
        when(requestBodyUriSpec.uri(anyString())).thenReturn(requestBodyUriSpec);
        when(requestBodyUriSpec.header(anyString(), anyString())).thenReturn(requestBodyUriSpec);
        when(requestHeadersSpec.retrieve()).thenReturn(responseSpec);
    }

    @Test
     void When_EmailRequestIsValid_Expect_SendEmailIsSuccessful() {
        when(responseSpec.bodyToMono(Void.class)).thenReturn(Mono.empty());

        Mockito.doReturn( requestBodyUriSpec ).when( integrationWebClient ).post();
        Mockito.doReturn( requestBodySpec ).when( requestBodyUriSpec ).uri("/notification-sender/email");
        Mockito.doReturn( requestHeadersSpec ).when( requestBodySpec ).bodyValue( Mockito.any() );
        Mockito.doReturn( responseSpec ).when( requestHeadersSpec ).retrieve();

        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();

        apiIntegrationImpl.sendEmail(govUkEmailDetailsRequest);


        Assertions.assertEquals("/chs-gov-uk-notify-integration-api/email", requestBodyUriSpec);
        Assertions.assertEquals(govUkEmailDetailsRequest, requestBodySpec);
    }
}