package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import helpers.OutputCapture;
import jakarta.validation.ConstraintViolationException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFunction;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;

import static helpers.utils.OutputAssertions.assertJsonHasAndEquals;
import static helpers.utils.OutputAssertions.getDataFromLog;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrowsExactly;

@SpringBootTest
@Tag("unit-test")
class ApiIntegrationInterfaceTest {


    @Autowired
    private NotifyIntegrationService notifyIntegrationService;

    @Test
    void When_NullEmailRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendEmailMessageToIntegrationApi(null),
                "Should throw ConstraintViolationException for null email request");
    }

    @Test
    void When_EmptyEmailRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendEmailMessageToIntegrationApi(
                        new GovUkEmailDetailsRequest()),
                "Should throw ConstraintViolationException for empty email request");
    }

    @Test
    void When_NullLetterRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendLetterMessageToIntegrationApi(null),
                "Should throw ConstraintViolationException for null letter request");
    }

    @Test
    void When_EmptyLetterRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendLetterMessageToIntegrationApi(
                        new GovUkLetterDetailsRequest()),
                "Should throw ConstraintViolationException for empty letter request");
    }

    @Test
    void When_ErrorIsThrown_Expect_ErrorLogMessage() throws IOException {
        WebClient client = WebClient.builder()
                .exchangeFunction(request -> Mono.error(
                        WebClientResponseException.create(
                                500, "Internal Service Error", null,
                                "Body Text".getBytes(StandardCharsets.UTF_8), null
                        )))
                .build();

        NotifyIntegrationService service = new NotifyIntegrationService(client);

        try (var outputCapture = new OutputCapture()) {
            service.sendEmailMessageToIntegrationApi(new GovUkEmailDetailsRequest())
                    .onErrorResume(e -> Mono.empty()) // absorb error for test
                    .block(); // trigger the call

            var amountOfErrorLogs = outputCapture.findAmountByEvent("error");
            assertEquals(1, amountOfErrorLogs,
                    "Should show an error log for the failed API call");

            var errorLog = getDataFromLog(outputCapture, "error", 0);
            assertJsonHasAndEquals(errorLog, "uri", "/email");
            assertJsonHasAndEquals(errorLog, "message", "Email API call failed");
            assertJsonHasAndEquals(errorLog, "status", "500");
        }
    }

    @Test
    void When_ValidEmailRequest_Expect_SuccessfulCall() throws IOException {
        ExchangeFunction exchangeFunction = clientRequest -> Mono.just(
                ClientResponse.create(HttpStatus.NO_CONTENT)
                        .body("")
                        .build());

        WebClient client = WebClient.builder()
                .exchangeFunction(exchangeFunction)
                .build();

        try (var outputCapture = new OutputCapture()) {
            NotifyIntegrationService service = new NotifyIntegrationService(client);

            var amountOfErrorLogs = outputCapture.findAmountByEvent("error");
            assertEquals(0, amountOfErrorLogs,
                    "Should not log an error for a successful response");

            assertDoesNotThrow(() ->
                    service.sendEmailMessageToIntegrationApi(new GovUkEmailDetailsRequest())
                            .block());
        }

    }

}
