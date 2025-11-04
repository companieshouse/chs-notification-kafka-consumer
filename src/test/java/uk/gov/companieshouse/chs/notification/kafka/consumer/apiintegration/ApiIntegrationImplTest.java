package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;

import static com.google.common.net.HttpHeaders.X_REQUEST_ID;
import static org.mockito.Mockito.verify;
import static uk.gov.companieshouse.chs.notification.kafka.consumer.Constants.TOKEN_CONTEXT_ID;

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
    private NotifyIntegrationService apiIntegrationImpl;

    @Test
    void When_EmailRequestIsValid_Expect_EmailMessageIsSentSuccessfully() {
        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();
        ResponseEntity<Void> responseEntity = ResponseEntity.ok().build();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header(X_REQUEST_ID,
                TOKEN_CONTEXT_ID);
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.just(responseEntity)).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(govUkEmailDetailsRequest,
                TOKEN_CONTEXT_ID);

        verify(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        verify(requestBodyUriSpec).uri("/email");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_EmailRequestFails_Expect_NoAcknowledgment() {
        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header(X_REQUEST_ID,
                TOKEN_CONTEXT_ID);
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.error(new RuntimeException("Error"))).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(govUkEmailDetailsRequest,
                TOKEN_CONTEXT_ID);

        verify(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        verify(requestBodyUriSpec).uri("/email");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_LetterRequestIsValid_Expect_LetterMessageIsSentSuccessfully() {
        GovUkLetterDetailsRequest govUkLetterDetailsRequest = new GovUkLetterDetailsRequest();
        ResponseEntity<Void> responseEntity = ResponseEntity.ok().build();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header(X_REQUEST_ID,
                TOKEN_CONTEXT_ID);
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.just(responseEntity)).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(govUkLetterDetailsRequest,
                TOKEN_CONTEXT_ID);

        verify(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        verify(requestBodyUriSpec).uri("/letter");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_LetterRequestFails_Expect_NoAcknowledgment() {
        GovUkLetterDetailsRequest govUkLetterDetailsRequest = new GovUkLetterDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header(X_REQUEST_ID,
                TOKEN_CONTEXT_ID);
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.error(new RuntimeException("Error"))).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(govUkLetterDetailsRequest,
                TOKEN_CONTEXT_ID);

        verify(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        verify(requestBodyUriSpec).uri("/letter");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }
}
