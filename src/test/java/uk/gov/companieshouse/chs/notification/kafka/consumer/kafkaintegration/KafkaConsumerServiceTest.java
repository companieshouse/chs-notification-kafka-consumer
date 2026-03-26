package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import static helpers.utils.OutputAssertions.assertJsonHasAndEquals;
import static helpers.utils.OutputAssertions.getDataFromLogMessage;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.fasterxml.jackson.databind.JsonNode;
import consumer.exception.NonRetryableErrorException;
import helpers.OutputCapture;
import java.io.IOException;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.test.util.ReflectionTestUtils;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs.notification.integration.model.EmailRequest;
import uk.gov.companieshouse.api.chs.notification.integration.model.LetterRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.NotifyIntegrationService;
import uk.gov.companieshouse.logging.EventType;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;
import uk.gov.companieshouse.notification.SenderDetails;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
class KafkaConsumerServiceTest {

    @Mock
    private NotifyIntegrationService notifyIntegrationService;

    @Mock
    private Acknowledgment acknowledgment;

    @InjectMocks
    private KafkaConsumerService kafkaConsumerService;

    @Captor
    private ArgumentCaptor<EmailRequest> emailRequestCaptor;

    @Captor
    private ArgumentCaptor<LetterRequest> letterRequestCaptor;

    private static final String EMAIL_TOPIC = "chs-notification-email";
    private static final String LETTER_TOPIC = "chs-notification-letter";

    private ChsEmailNotification mockEmailNotification;
    private ChsLetterNotification mockLetterNotification;
    private ConsumerRecord<String, ChsEmailNotification> emailRecord;
    private ConsumerRecord<String, ChsLetterNotification> letterRecord;

    private static final String LETTER_DEBUG_LOG_MESSAGE = "Consuming letter record: ";

    @BeforeEach
    void setUp() {
        mockEmailNotification = new ChsEmailNotification();
        mockLetterNotification = new ChsLetterNotification();
        SenderDetails emailSenderDetails = new SenderDetails();
        emailSenderDetails.setAppId("app-id");
        emailSenderDetails.setReference("email-ref-123");
        mockEmailNotification.setSenderDetails(emailSenderDetails);

        SenderDetails letterSenderDetails = new SenderDetails();
        letterSenderDetails.setAppId("app-id");
        letterSenderDetails.setReference("letter-ref-456");
        mockLetterNotification.setSenderDetails(letterSenderDetails);

        emailRecord = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", mockEmailNotification);
        letterRecord = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", mockLetterNotification);

        ReflectionTestUtils.setField(kafkaConsumerService, "kafkaMaxAttempts", 5);
    }

    @Test
    void When_ConsumingValidEmailMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                any())).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Then
        verify(notifyIntegrationService)
                .sendEmailMessageToIntegrationApi(emailRequestCaptor.capture());
        assertEquals(mockEmailNotification.getSenderDetails().getAppId(),
                emailRequestCaptor.getValue().getAppId());
        assertEquals(mockEmailNotification.getSenderDetails().getReference(),
                emailRequestCaptor.getValue().getReference());
    }

    @Test
    void When_ConsumingValidLetterMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                any())).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

        }

        // Then
        verify(notifyIntegrationService)
                .sendLetterMessageToIntegrationApi(letterRequestCaptor.capture());
        assertEquals(mockLetterNotification.getSenderDetails().getAppId(),
                letterRequestCaptor.getValue().getAppId());
        assertEquals(mockLetterNotification.getSenderDetails().getReference(),
                letterRequestCaptor.getValue().getReference());
    }

    @Test
    void When_EmailApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment()
            throws IOException {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                any())).thenReturn(Mono.error(apiException));

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Then
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(any());
    }

    @Test
    void When_LetterApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment() {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                any())).thenReturn(Mono.error(apiException));

        // When/Then
        assertThrows(RuntimeException.class,
                () -> kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment));

        // Then
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(any());
    }

    @Test
    void When_EmailApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given - Configure the test class so we can verify behavior across multiple method calls
        KafkaConsumerService spyKafkaConsumerService = Mockito.spy(kafkaConsumerService);

        // First call fails, second call succeeds
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                any())).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        try (var outputCapture = new OutputCapture()) {
            // When - Second call should succeed
            spyKafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment);

        }

        // Then - Verify the retry succeeded and was acknowledged
        verify(notifyIntegrationService, times(2))
                .sendEmailMessageToIntegrationApi(emailRequestCaptor.capture());
        for (EmailRequest req : emailRequestCaptor.getAllValues()) {
            assertEquals(mockEmailNotification.getSenderDetails().getAppId(),
                    req.getAppId());
            assertEquals(mockEmailNotification.getSenderDetails().getReference(),
                    req.getReference());
        }
    }

    @Test
    void When_LetterApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given - Configure the test class so we can verify behavior across multiple method calls
        KafkaConsumerService spyKafkaConsumerService = Mockito.spy(kafkaConsumerService);

        // First call fails, second call succeeds
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                any())).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeLetterMessage(null, letterRecord,
                            acknowledgment));

        }

        // When - Second call should succeed
        try (var outputCapture = new OutputCapture()) {
            spyKafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

        }

        // Then - Verify the retry succeeded and was acknowledged
        verify(notifyIntegrationService, times(2))
                .sendLetterMessageToIntegrationApi(letterRequestCaptor.capture());
        for (LetterRequest req : letterRequestCaptor.getAllValues()) {
            assertEquals(mockLetterNotification.getSenderDetails().getAppId(),
                    req.getAppId());
            assertEquals(mockLetterNotification.getSenderDetails().getReference(),
                    req.getReference());
        }
    }

    @Test
    void When_Email_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                any())).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

        }

        // Then
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(any());
    }

    @Test
    void When_Letter_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                any())).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeLetterMessage(5, letterRecord, acknowledgment));

        }

        // Then
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(any());
    }

    private void assertEmailCommonFields(JsonNode data) {
        assertCommonFields(data, EMAIL_TOPIC, mockEmailNotification.toString());
    }

    private void assertLetterCommonFields(JsonNode data) {
        assertCommonFields(data, LETTER_TOPIC, mockLetterNotification.toString());
    }

    private void assertCommonFields(JsonNode data, String topic, String kafkaMessage) {
        assertJsonHasAndEquals(data, "topic", topic);
        assertJsonHasAndEquals(data, "partition", "0");
        assertJsonHasAndEquals(data, "offset", "0");
        assertJsonHasAndEquals(data, "kafka_message", kafkaMessage);
    }


}
