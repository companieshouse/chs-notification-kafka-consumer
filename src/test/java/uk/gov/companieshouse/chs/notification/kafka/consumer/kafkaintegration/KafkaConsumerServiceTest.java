package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import consumer.exception.NonRetryableErrorException;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.ApiIntegrationInterface;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.KafkaTranslatorInterface;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
public class KafkaConsumerServiceTest {
    @Mock
    private KafkaTranslatorInterface kafkaTranslatorInterface;

    @Mock
    private ApiIntegrationInterface apiIntegrationInterface;

    @Mock
    private Acknowledgment acknowledgment;

    @InjectMocks
    private KafkaConsumerService kafkaConsumerService;

    private static final String EMAIL_TOPIC = "chs-notification-email";
    private static final String LETTER_TOPIC = "chs-notification-letter";

    private byte[] validEmailMessage;
    private byte[] validLetterMessage;
    private GovUkEmailDetailsRequest mockEmailRequest;
    private GovUkLetterDetailsRequest mockLetterRequest;

    @BeforeEach
    void setUp() {
        validEmailMessage = "valid-email-message".getBytes();
        mockEmailRequest = new GovUkEmailDetailsRequest();
        validLetterMessage = "valid-letter-message".getBytes();
        mockLetterRequest = new GovUkLetterDetailsRequest();
    }

    @Test
    void should_Consume_Email_Message_Successfully() {
        ConsumerRecord<String, byte[]> record = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", validEmailMessage);
        when(kafkaTranslatorInterface.translateEmailKafkaMessage(record.value())).thenReturn(mockEmailRequest);

        kafkaConsumerService.consumeEmailMessage(record, acknowledgment);

        verify(kafkaTranslatorInterface).translateEmailKafkaMessage(validEmailMessage);
        verify(apiIntegrationInterface).sendEmailMessageToIntegrationApi(mockEmailRequest, acknowledgment);
    }

    @Test
    void should_Consume_Letter_Message_Successfully() {
        ConsumerRecord<String, byte[]> record = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", validLetterMessage);
        when(kafkaTranslatorInterface.translateLetterKafkaMessage(record.value())).thenReturn(mockLetterRequest);

        kafkaConsumerService.consumeLetterMessage(record, acknowledgment);

        verify(kafkaTranslatorInterface).translateLetterKafkaMessage(validLetterMessage);
        verify(apiIntegrationInterface).sendLetterMessageToIntegrationApi(mockLetterRequest, acknowledgment);
    }

    @Test
    void should_Not_Call_Api_Integration_For_Null_Email_Message() {
        byte[] messageBytes = null;
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0, "key", messageBytes);

        assertThrows(IllegalArgumentException.class, () -> kafkaConsumerService.consumeEmailMessage(mockRecord, acknowledgment));

        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }

    @Test
    void should_Not_Call_Api_Integration_For_Null_Letter_Message() {
        byte[] messageBytes = null;
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>(LETTER_TOPIC, 0, 0, "key", messageBytes);

        assertThrows(IllegalArgumentException.class, () -> kafkaConsumerService.consumeLetterMessage(mockRecord, acknowledgment));

        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }

    @Test
    void should_Handle_Exception_During_Email_Message_Processing() {
        byte[] messageBytes = "faulty-email-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("email-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateEmailKafkaMessage(messageBytes))
                .thenThrow(new NonRetryableErrorException("Translation failed"));

        assertThrows(NonRetryableErrorException.class, () -> kafkaConsumerService.consumeEmailMessage(mockRecord, acknowledgment));

        verify(kafkaTranslatorInterface).translateEmailKafkaMessage(messageBytes);
        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }

    @Test
    void should_Handle_Exception_During_Letter_Message_Processing() {
        byte[] messageBytes = "faulty-letter-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("letter-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateLetterKafkaMessage(messageBytes))
                .thenThrow(new NonRetryableErrorException("Translation failed"));

        assertThrows(NonRetryableErrorException.class, () -> kafkaConsumerService.consumeLetterMessage(mockRecord, acknowledgment));

        verify(kafkaTranslatorInterface).translateLetterKafkaMessage(messageBytes);
        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }
}
