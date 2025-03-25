package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_gov_uk_notify_integration_api.model.*;

import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
class ApiIntegrationImplTest {

    @Mock
    private WebClient integrationWebClient;

    @Mock
    private WebClient.RequestBodyUriSpec requestBodyUriSpec;

    @Mock
    private WebClient.RequestBodySpec requestBodySpec;

    @Mock
    private WebClient.RequestHeadersSpec requestHeadersSpec;

    @Mock
    private WebClient.ResponseSpec responseSpec;

    @InjectMocks
    private ApiIntegrationImpl apiIntegrationImpl;

    @Test
     void When_EmailRequestIsValid_Expect_SendEmailIsSuccessful() {
        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();

        Mockito.doReturn( requestBodyUriSpec ).when( integrationWebClient ).post();
        Mockito.doReturn( requestBodySpec ).when( requestBodyUriSpec ).uri("/chs-gov-uk-notify-integration-api/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn( requestHeadersSpec ).when( requestBodySpec ).bodyValue( govUkEmailDetailsRequest );
        Mockito.doReturn( responseSpec ).when( requestHeadersSpec ).retrieve();
        Mockito.doReturn( Mono.empty() ).when( responseSpec ).bodyToMono( Void.class );


        apiIntegrationImpl.sendEmail( govUkEmailDetailsRequest );

        verify(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/email");
        verify(responseSpec).bodyToMono(Void.class);
    }

    @Test
    void When_LetterRequestIsValid_Expect_SendLetterIsSuccessful() {
        GovUkLetterDetailsRequest govUkLetterDetailsRequest = new GovUkLetterDetailsRequest();

        Mockito.doReturn( requestBodyUriSpec ).when( integrationWebClient ).post();
        Mockito.doReturn( requestBodySpec ).when( requestBodyUriSpec ).uri("/chs-gov-uk-notify-integration-api/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn( requestHeadersSpec ).when( requestBodySpec ).bodyValue( govUkLetterDetailsRequest );
        Mockito.doReturn( responseSpec ).when( requestHeadersSpec ).retrieve();
        Mockito.doReturn( Mono.empty() ).when( responseSpec ).bodyToMono( Void.class );


        apiIntegrationImpl.sendLetter( govUkLetterDetailsRequest );

        verify(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/letter");
        verify(responseSpec).bodyToMono(Void.class);
    }

    @Test
    void When_EmailRequestIsNull_Expect_ExceptionToBeThrown(){
        Assertions.assertThrows( NullPointerException.class, () -> apiIntegrationImpl.sendEmail( null ) );
    }
}