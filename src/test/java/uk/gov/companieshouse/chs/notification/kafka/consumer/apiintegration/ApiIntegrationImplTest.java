package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import java.util.function.Function;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import org.springframework.http.HttpStatus;

import static org.mockito.Mockito.*;

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
    private Acknowledgment acknowledgment;

    @Mock
    private ClientResponse clientResponse;

    @InjectMocks
    private ApiIntegrationImpl apiIntegrationImpl;

    @Test
    void When_EmailRequestIsValid_Expect_EmailMessageIsSentSuccessfully() {
        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkEmailDetailsRequest);

        when(clientResponse.statusCode()).thenReturn(HttpStatus.OK);

        ArgumentCaptor<Function<ClientResponse, Mono<Void>>> functionCaptor =
                ArgumentCaptor.forClass(Function.class);
        when(requestHeadersSpec.exchangeToMono(functionCaptor.capture()))
                .thenReturn(Mono.empty());

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(govUkEmailDetailsRequest, acknowledgment::acknowledge);

        verify(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/email");

        functionCaptor.getValue().apply(clientResponse);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_EmailRequestFails_Expect_NoAcknowledgment() {
        GovUkEmailDetailsRequest govUkEmailDetailsRequest = new GovUkEmailDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/email");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkEmailDetailsRequest);

        when(clientResponse.statusCode()).thenReturn(HttpStatus.INTERNAL_SERVER_ERROR);

        ArgumentCaptor<Function<ClientResponse, Mono<Void>>> functionCaptor =
                ArgumentCaptor.forClass(Function.class);
        when(requestHeadersSpec.exchangeToMono(functionCaptor.capture()))
                .thenReturn(Mono.empty());

        apiIntegrationImpl.sendEmailMessageToIntegrationApi(govUkEmailDetailsRequest, acknowledgment::acknowledge);

        verify(requestBodySpec).bodyValue(govUkEmailDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/email");

        functionCaptor.getValue().apply(clientResponse);
        verify(acknowledgment, never()).acknowledge();
    }

    @Test
    void When_LetterRequestIsValid_Expect_LetterMessageIsSentSuccessfully() {
        GovUkLetterDetailsRequest govUkLetterDetailsRequest = new GovUkLetterDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkLetterDetailsRequest);

        when(clientResponse.statusCode()).thenReturn(HttpStatus.OK);

        ArgumentCaptor<Function<ClientResponse, Mono<Void>>> functionCaptor =
                ArgumentCaptor.forClass(Function.class);
        when(requestHeadersSpec.exchangeToMono(functionCaptor.capture()))
                .thenReturn(Mono.empty());

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(govUkLetterDetailsRequest, acknowledgment::acknowledge);

        verify(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/letter");

        functionCaptor.getValue().apply(clientResponse);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_LetterRequestFails_Expect_NoAcknowledgment() {
        GovUkLetterDetailsRequest govUkLetterDetailsRequest = new GovUkLetterDetailsRequest();

        Mockito.doReturn(requestBodyUriSpec).when(integrationWebClient).post();
        Mockito.doReturn(requestBodySpec).when(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/letter");
        Mockito.doReturn(requestBodySpec).when(requestBodySpec).header("Content-Type", "application/json");
        Mockito.doReturn(requestHeadersSpec).when(requestBodySpec).bodyValue(govUkLetterDetailsRequest);

        when(clientResponse.statusCode()).thenReturn(HttpStatus.INTERNAL_SERVER_ERROR);

        ArgumentCaptor<Function<ClientResponse, Mono<Void>>> functionCaptor =
                ArgumentCaptor.forClass(Function.class);
        when(requestHeadersSpec.exchangeToMono(functionCaptor.capture()))
                .thenReturn(Mono.empty());

        apiIntegrationImpl.sendLetterMessageToIntegrationApi(govUkLetterDetailsRequest, acknowledgment::acknowledge);

        verify(requestBodySpec).bodyValue(govUkLetterDetailsRequest);
        verify(requestBodyUriSpec).uri("/chs-gov-uk-notify-integration-api/letter");

        functionCaptor.getValue().apply(clientResponse);
        verify(acknowledgment, never()).acknowledge();
    }
}
