package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import helpers.OutputCapture;
import com.fasterxml.jackson.databind.JsonNode;
import consumer.exception.NonRetryableErrorException;
import java.io.IOException;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import reactor.core.publisher.Mono;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.NotifyIntegrationService;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.MessageMapper;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;
import uk.gov.companieshouse.notification.SenderDetails;


import static helpers.utils.OutputAssertions.assertJsonHasAndEquals;
import static helpers.utils.OutputAssertions.getDataFromLogMessage;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
class KafkaConsumerServiceTest {

    @Mock
    private MessageMapper messageMapper;

    @Mock
    private NotifyIntegrationService notifyIntegrationService;

    @Mock
    private Acknowledgment acknowledgment;

    @InjectMocks
    private KafkaConsumerService kafkaConsumerService;

    private static final String EMAIL_TOPIC = "chs-notification-email";
    private static final String LETTER_TOPIC = "chs-notification-letter";

    private ChsEmailNotification mockEmailNotification;
    private ChsLetterNotification mockLetterNotification;
    private GovUkEmailDetailsRequest mockEmailRequest;
    private GovUkLetterDetailsRequest mockLetterRequest;
    private ConsumerRecord<String, ChsEmailNotification> emailRecord;
    private ConsumerRecord<String, ChsLetterNotification> letterRecord;

    @BeforeEach
    void setUp() {
        mockEmailNotification = new ChsEmailNotification();
        mockLetterNotification = new ChsLetterNotification();
        SenderDetails emailSenderDetails = new SenderDetails();
        emailSenderDetails.setReference("email-ref-123");
        mockEmailNotification.setSenderDetails(emailSenderDetails);

        SenderDetails letterSenderDetails = new SenderDetails();
        letterSenderDetails.setReference("letter-ref-456");
        mockLetterNotification.setSenderDetails(letterSenderDetails);

        mockEmailRequest = new GovUkEmailDetailsRequest();
        mockLetterRequest = new GovUkLetterDetailsRequest();

        emailRecord = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", mockEmailNotification);
        letterRecord = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", mockLetterNotification);
    }

    @Test
    void When_ConsumingValidEmailMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest)).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment);

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_ConsumingValidLetterMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest)).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment);

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming letter record: " + letterRecord);
            assertCommonFields(debugData, LETTER_TOPIC, mockLetterNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming letter record with sender reference: letter-ref-456");
            assertCommonFields(infoData, LETTER_TOPIC, mockLetterNotification.toString());

        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_EmailMessageMappingFails_Expect_ExceptionThrownAndNoAcknowledgment()
            throws IOException {
        // Given
        RuntimeException mappingException = new RuntimeException("Mapping failed");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenThrow(
                mappingException);

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug", "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info", "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());

            assertEquals(0, outputCapture.findAmountByEvent("error"),
                    "No error logs should be generated for mapping failure");

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verifyNoInteractions(notifyIntegrationService);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_LetterMessageMappingFails_Expect_ExceptionThrownAndNoAcknowledgment()
            throws IOException {
        // Given
        RuntimeException mappingException = new RuntimeException("Mapping failed");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenThrow(
                mappingException);

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment));

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug", "Consuming letter record: " + letterRecord);
            assertCommonFields(debugData, LETTER_TOPIC, mockLetterNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info", "Consuming letter record with sender reference: letter-ref-456");
            assertCommonFields(infoData, LETTER_TOPIC, mockLetterNotification.toString());
        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verifyNoInteractions(notifyIntegrationService);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_EmailApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment()
            throws IOException {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest)).thenReturn(Mono.error(apiException));

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug", "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info", "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, "error",
                    "Failed to send email request to integration API");
            assertJsonHasAndEquals(errorData, "error_message", "API failed");
            assertCommonFields(errorData, EMAIL_TOPIC, mockEmailNotification.toString());

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_LetterApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment() {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest)).thenReturn(Mono.error(apiException));

        // When/Then
        assertThrows(RuntimeException.class,
                () -> kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment));

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_EmailApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given - Configure the test class so we can verify behavior across multiple method calls
        KafkaConsumerService spyKafkaConsumerService = Mockito.spy(kafkaConsumerService);

        // First call fails, second call succeeds
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest)).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, "error",
                    "Failed to send email request to integration API");
            assertJsonHasAndEquals(errorData, "error_message", "First attempt failed");
            assertCommonFields(errorData, EMAIL_TOPIC, mockEmailNotification.toString());

        }

        // Verify first attempt behavior
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest);
        verifyNoInteractions(acknowledgment);

        try (var outputCapture = new OutputCapture()) {
            // When - Second call should succeed
            spyKafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment);

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());
        }
        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService, times(2)).sendEmailMessageToIntegrationApi(
                mockEmailRequest);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_LetterApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given - Configure the test class so we can verify behavior across multiple method calls
        KafkaConsumerService spyKafkaConsumerService = Mockito.spy(kafkaConsumerService);

        // First call fails, second call succeeds
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest)).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeLetterMessage(letterRecord,
                            acknowledgment));

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming letter record: " + letterRecord);
            assertCommonFields(debugData, LETTER_TOPIC, mockLetterNotification.toString());

            // Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming letter record with sender reference: letter-ref-456");
            assertCommonFields(infoData, LETTER_TOPIC, mockLetterNotification.toString());

            // Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, "error",
                    "Failed to send letter request to integration API");
            assertJsonHasAndEquals(errorData, "error_message", "First attempt failed");
            assertCommonFields(errorData, LETTER_TOPIC, mockLetterNotification.toString());
        }

        // Verify first attempt behavior
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest);
        verifyNoInteractions(acknowledgment);

        // When - Second call should succeed
        try (var outputCapture = new OutputCapture()) {
            spyKafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment);

            // Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming letter record: " + letterRecord);
            assertCommonFields(debugData, "chs-notification-letter",
                    mockLetterNotification.toString());

            // Test Info Log Message
            getDataFromLogMessage(outputCapture, "info",
                    "Consuming letter record with sender reference: letter-ref-456");

        }

        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService, times(2)).sendLetterMessageToIntegrationApi(
                mockLetterRequest);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest)).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            // Test Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, "info",
                    "Consuming email record with sender reference: email-ref-123");
            assertCommonFields(infoData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Test Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, "error",
                    "Failed to send email request to integration API");
            assertCommonFields(errorData, EMAIL_TOPIC, mockEmailNotification.toString());

            // Test Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, "debug",
                    "Consuming email record: " + emailRecord);
            assertCommonFields(debugData, EMAIL_TOPIC, mockEmailNotification.toString());

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest);
        verifyNoInteractions(acknowledgment);
    }


    private void assertCommonFields(JsonNode data, String topic, String kafkaMessage) {
        assertJsonHasAndEquals(data, "topic", topic);
        assertJsonHasAndEquals(data, "partition", "0");
        assertJsonHasAndEquals(data, "offset", "0");
        assertJsonHasAndEquals(data, "kafka_message", kafkaMessage);
    }


}
