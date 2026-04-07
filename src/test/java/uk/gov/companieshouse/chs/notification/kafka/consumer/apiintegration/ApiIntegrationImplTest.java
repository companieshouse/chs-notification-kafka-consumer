package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import static org.mockito.Mockito.verify;

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
import uk.gov.companieshouse.api.chs.notification.integration.model.EmailRequest;
import uk.gov.companieshouse.api.chs.notification.integration.model.LetterRequest;

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
        EmailRequest request = new EmailRequest();
        ResponseEntity<Void> responseEntity = ResponseEntity.ok().build();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(request);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.just(responseEntity)).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(request);

        verify(requestBodySpec).bodyValue(request);
        verify(requestBodyUriSpec).uri("/email");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_EmailRequestFails_Expect_NoAcknowledgment() {
        EmailRequest request = new EmailRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(request);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.error(new RuntimeException("Error"))).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(request);

        verify(requestBodySpec).bodyValue(request);
        verify(requestBodyUriSpec).uri("/email");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_LetterRequestIsValid_Expect_LetterMessageIsSentSuccessfully() {
        LetterRequest request = new LetterRequest();
        ResponseEntity<Void> responseEntity = ResponseEntity.ok().build();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(request);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.just(responseEntity)).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(request);

        verify(requestBodySpec).bodyValue(request);
        verify(requestBodyUriSpec).uri("/letter");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }

    @Test
    void When_LetterRequestFails_Expect_NoAcknowledgment() {
        LetterRequest request = new LetterRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(request);
        Mockito.doReturn(responseSpec).when(requestHeadersSpec).retrieve();
        Mockito.doReturn(Mono.error(new RuntimeException("Error"))).when(responseSpec).toBodilessEntity();

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(request);

        verify(requestBodySpec).bodyValue(request);
        verify(requestBodyUriSpec).uri("/letter");
        verify(requestHeadersSpec).retrieve();
        verify(responseSpec).toBodilessEntity();
    }
}
