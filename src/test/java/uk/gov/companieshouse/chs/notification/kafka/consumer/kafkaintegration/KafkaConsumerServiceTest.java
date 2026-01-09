package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import helpers.OutputCapture;
import com.fasterxml.jackson.databind.JsonNode;
import consumer.exception.NonRetryableErrorException;
import java.io.IOException;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.test.util.ReflectionTestUtils;
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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
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
    @Spy
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

    private static final String INCOMING_CONTEXT_ID = "incoming-context-id";
    private static final String GENERATED_CONTEXT_ID = "generated-context-id";
    private static final ChsEmailNotification EMAIL_NOTIFICATION = new ChsEmailNotification();
    private static final ChsLetterNotification LETTER_NOTIFICATION = new ChsLetterNotification();
    private static final ConsumerRecord<String, ChsEmailNotification> EMAIL_WITH_CONTEXT_ID;
    private static final ConsumerRecord<String, ChsLetterNotification> LETTER_WITH_CONTEXT_ID;

    static {
        var emailSenderDetails = new SenderDetails();
        emailSenderDetails.setReference("email-ref-123");
        EMAIL_NOTIFICATION.setSenderDetails(emailSenderDetails);
        EMAIL_WITH_CONTEXT_ID = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", EMAIL_NOTIFICATION);
        EMAIL_WITH_CONTEXT_ID.headers().add(X_REQUEST_ID, INCOMING_CONTEXT_ID.getBytes());

        var letterSenderDetails = new SenderDetails();
        letterSenderDetails.setReference("letter-ref-456");
        LETTER_NOTIFICATION.setSenderDetails(letterSenderDetails);
        LETTER_WITH_CONTEXT_ID = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", LETTER_NOTIFICATION);
        LETTER_WITH_CONTEXT_ID.headers().add(X_REQUEST_ID, INCOMING_CONTEXT_ID.getBytes());
    }


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

        ReflectionTestUtils.setField(kafkaConsumerService, "kafkaMaxAttempts", 5);
    }

    @Test
    void When_ConsumingValidEmailMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString());
    }

    @Test
    void When_ConsumingValidLetterMessage_Expect_MessageSentAndAcknowledged() throws IOException {
        // Given
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When
            kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(eq(mockLetterRequest),
                anyString());
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
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verifyNoInteractions(notifyIntegrationService);
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
                    () -> kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment));
        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verifyNoInteractions(notifyIntegrationService);
    }

    @Test
    void When_EmailApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment()
            throws IOException {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(Mono.error(apiException));

        try (var outputCapture = new OutputCapture()) {
            // When/Then
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString());
    }

    @Test
    void When_LetterApiIntegrationFails_Expect_ExceptionThrownAndNoAcknowledgment() {
        // Given
        RuntimeException apiException = new RuntimeException("API failed");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(Mono.error(apiException));

        // When/Then
        assertThrows(RuntimeException.class,
                () -> kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment));

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString());
    }

    @Test
    void When_EmailApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given
        // First call fails, second call succeeds
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG,
                    "Consuming email record: " + emailRecord);
            assertEmailCommonFields(debugData);

        }

        // Verify first attempt behavior
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString());

        try (var outputCapture = new OutputCapture()) {
            // When - Second call should succeed
            kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment);

        }
        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService, times(2)).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString());
    }

    @Test
    void When_LetterApiIntegrationFailsThenSucceeds_Expect_MessageRetryAndAcknowledgment()
            throws IOException {
        // Given
        // First call fails, second call succeeds
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(
                Mono.error(new RuntimeException("First attempt failed"))).thenReturn(Mono.empty());

        try (var outputCapture = new OutputCapture()) {
            // When - First call will throw exception
            assertThrows(RuntimeException.class,
                    () -> kafkaConsumerService.consumeLetterMessage(null, letterRecord,
                            acknowledgment));

        }

        // Verify first attempt behavior
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString());
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString());

        // When - Second call should succeed
        try (var outputCapture = new OutputCapture()) {
            kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment);

            var debugData = getDataFromLogMessage(outputCapture, EventType.DEBUG, LETTER_DEBUG_LOG_MESSAGE + letterRecord);
            assertLetterCommonFields(debugData);

        }

        // Then - Verify the retry succeeded and was acknowledged
        verify(messageMapper, times(2)).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService, times(2)).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString());
    }

    @Test
    void When_Email_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment));

        }

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString());
    }

    @Test
    void When_Letter_NonRetryableErrorOccurs_Expect_ExceptionPropagated() throws IOException {
        // Given
        NonRetryableErrorException nonRetryableError = new NonRetryableErrorException(
                "Do not retry this error");
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(Mono.error(nonRetryableError));

        try (var outputCapture = new OutputCapture()) {
            // When/Then - Exception should propagate without retry
            assertThrows(NonRetryableErrorException.class,
                    () -> kafkaConsumerService.consumeLetterMessage(5, letterRecord, acknowledgment));

        }

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString());
    }

    @Test
    @DisplayName("An incoming context ID on an email message is propagated on")
    void incomingEmailContextIdIsPropagated() {

        // Given
        when(messageMapper.mapToEmailDetailsRequest(EMAIL_NOTIFICATION)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(Mono.empty());

        // When
        kafkaConsumerService.consumeEmailMessage(null, EMAIL_WITH_CONTEXT_ID, acknowledgment);

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(EMAIL_NOTIFICATION);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                mockEmailRequest, INCOMING_CONTEXT_ID);
    }

    @Test
    @DisplayName("A context ID is generated and propagated on for an email message that does not already have one")
    void emailGeneratedContextIdIsPropagated() {

        // Given
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(
                mockEmailRequest);
        when(notifyIntegrationService.sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest), anyString())).thenReturn(Mono.empty());
        when(kafkaConsumerService.generateUniqueContextId()).thenReturn(GENERATED_CONTEXT_ID);

        // When
        kafkaConsumerService.consumeEmailMessage(null, emailRecord, acknowledgment);

        // Then
        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(notifyIntegrationService).sendEmailMessageToIntegrationApi(
                mockEmailRequest, GENERATED_CONTEXT_ID);
    }

    @Test
    @DisplayName("An incoming context ID on a send letter message is propagated on")
    void incomingLetterContextIdIsPropagated() {

        // Given
        when(messageMapper.mapToLetterDetailsRequest(LETTER_NOTIFICATION)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(Mono.empty());

        // When
        kafkaConsumerService.consumeLetterMessage(null, LETTER_WITH_CONTEXT_ID, acknowledgment);

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(LETTER_NOTIFICATION);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                INCOMING_CONTEXT_ID);
    }

    @Test
    @DisplayName("A context ID is generated and propagated on for a letter message that does not already have one")
    void letterGeneratedContextIdIsPropagated() {

        // Given
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(
                mockLetterRequest);
        when(notifyIntegrationService.sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest), anyString())).thenReturn(Mono.empty());
        when(kafkaConsumerService.generateUniqueContextId()).thenReturn(GENERATED_CONTEXT_ID);

        // When
        kafkaConsumerService.consumeLetterMessage(null, letterRecord, acknowledgment);

        // Then
        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(notifyIntegrationService).sendLetterMessageToIntegrationApi(mockLetterRequest,
                GENERATED_CONTEXT_ID);
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
