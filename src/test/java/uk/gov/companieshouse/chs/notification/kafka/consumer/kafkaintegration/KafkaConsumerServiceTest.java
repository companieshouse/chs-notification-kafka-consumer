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
import uk.gov.companieshouse.logging.EventType;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;
import uk.gov.companieshouse.notification.SenderDetails;


import static com.google.common.net.HttpHeaders.X_REQUEST_ID;
import static helpers.utils.OutputAssertions.assertJsonHasAndEquals;
import static helpers.utils.OutputAssertions.getDataFromLogMessage;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static uk.gov.companieshouse.chs.notification.kafka.consumer.Constants.TOKEN_CONTEXT_ID;

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
    
    private static final String EMAIL_INFO_LOG_MESSAGE = "Consuming email record with sender reference: email-ref-123";
    private static final String EMAIL_ERROR_LOG_MESSAGE = "Failed to send email request to integration API";

    private static final String LETTER_INFO_LOG_MESSAGE = "Consuming letter record with sender reference: letter-ref-456";
    private static final String LETTER_DEBUG_LOG_MESSAGE = "Consuming letter record: ";
    private static final String LETTER_ERROR_LOG_MESSAGE = "Failed to send letter request to integration API";


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
        emailRecord.headers().add(X_REQUEST_ID, TOKEN_CONTEXT_ID.getBytes());
        letterRecord = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", mockLetterNotification);
        letterRecord.headers().add(X_REQUEST_ID, TOKEN_CONTEXT_ID.getBytes());
    }

    @Test
    void When_ConsumingValidEmailMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest,
                TOKEN_CONTEXT_ID);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_ConsumingValidLetterMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, LETTER_INFO_LOG_MESSAGE);
            assertLetterCommonFields(infoData);

        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest, TOKEN_CONTEXT_ID);
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

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);

            assertEquals(0, outputCapture.findAmountByEvent(EventType.ERROR),
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

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, LETTER_INFO_LOG_MESSAGE);
            assertLetterCommonFields(infoData);
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
                mockEmailRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.error(apiException));

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);

            var errorData = getDataFromLogMessage(outputCapture, EventType.ERROR, EMAIL_ERROR_LOG_MESSAGE);
            assertJsonHasAndEquals(errorData, "error_message", "API failed");
            assertEmailCommonFields(errorData);

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest,
                TOKEN_CONTEXT_ID);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_LetterApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment() {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.error(apiException));

        // When/Then
        assertThrows(RuntimeException.class,
                () -> kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment));

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                TOKEN_CONTEXT_ID);
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
                mockEmailRequest, TOKEN_CONTEXT_ID)).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);

            var errorData = getDataFromLogMessage(outputCapture, EventType.ERROR, EMAIL_ERROR_LOG_MESSAGE);
            assertJsonHasAndEquals(errorData, "error_message", "First attempt failed");
            assertEmailCommonFields(errorData);

        }

        // Verify first attempt behavior
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest,
                TOKEN_CONTEXT_ID);
        verifyNoInteractions(acknowledgment);

        try (var outputCapture = new OutputCapture()) {
            // When - Second call should succeed
            spyKafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);
        }
        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService, times(2)).sendEmailMessageToIntegrationApi(
                mockEmailRequest, TOKEN_CONTEXT_ID);
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
                mockLetterRequest, TOKEN_CONTEXT_ID)).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> spyKafkaConsumerService.consumeLetterMessage(letterRecord,
                            acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, LETTER_INFO_LOG_MESSAGE);
            assertLetterCommonFields(infoData);

            var errorData = getDataFromLogMessage(outputCapture, EventType.ERROR,
                    "Failed to send letter request to integration API");
            assertJsonHasAndEquals(errorData, "error_message", "First attempt failed");
            assertLetterCommonFields(errorData);
        }

        // Verify first attempt behavior
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                TOKEN_CONTEXT_ID);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                TOKEN_CONTEXT_ID);
        verifyNoInteractions(acknowledgment);

        // When - Second call should succeed
        try (var outputCapture = new OutputCapture()) {
            spyKafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

            // Test Info Log Message
            getDataFromLogMessage(outputCapture, EventType.INFO, LETTER_INFO_LOG_MESSAGE);

        }

        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService, times(2)).sendLetterMessageToIntegrationApi(
                mockLetterRequest, TOKEN_CONTEXT_ID);
        verify(acknowledgment).acknowledge();
    }

    @Test
    void When_Email_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                mockEmailRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(emailRecord, acknowledgment));

            // Test Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, EMAIL_INFO_LOG_MESSAGE);
            assertEmailCommonFields(infoData);

            // Test Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, EventType.ERROR, EMAIL_ERROR_LOG_MESSAGE);
            assertEmailCommonFields(errorData);

            // Test Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(mockEmailRequest,
                TOKEN_CONTEXT_ID);
        verifyNoInteractions(acknowledgment);
    }

    @Test
    void When_Letter_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                mockLetterRequest, TOKEN_CONTEXT_ID)).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeLetterMessage(letterRecord, acknowledgment));

            // Test Info Log Message
            var infoData = getDataFromLogMessage(outputCapture, EventType.INFO, LETTER_INFO_LOG_MESSAGE);
            assertLetterCommonFields(infoData);

            // Test Error Log Message
            var errorData = getDataFromLogMessage(outputCapture, EventType.ERROR, LETTER_ERROR_LOG_MESSAGE);
            assertLetterCommonFields(errorData);

            // Test Debug Log Message
            var debugData = getDataFromLogMessage(outputCapture,EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                TOKEN_CONTEXT_ID);
        verifyNoInteractions(acknowledgment);
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
