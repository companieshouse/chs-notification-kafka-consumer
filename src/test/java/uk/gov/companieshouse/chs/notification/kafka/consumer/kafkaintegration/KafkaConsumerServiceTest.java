package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.ApiIntegrationInterface;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.KafkaTranslatorInterface;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
public class KafkaConsumerServiceTest {
    @Mock
    private KafkaTranslatorInterface kafkaTranslatorInterface;

    @Mock
    private ApiIntegrationInterface apiIntegrationInterface;

    @InjectMocks
    private KafkaConsumerService kafkaConsumerService;

    private static final String EMAIL_TOPIC = "chs-notification-email";
    private static final String LETTER_TOPIC = "chs-notification-letter";

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    /*   @Test
    void shouldConsumeEmailMessageSuccessfully() {
        // Given
        byte[] messageBytes = "valid-email-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0, "key", messageBytes);

        GovUkEmailDetailsRequest mockEmailRequest = new GovUkEmailDetailsRequest();
        when(kafkaTranslatorInterface.translateEmailKafkaMessage(mockRecord.value())).thenReturn(mockEmailRequest);

        // When
        kafkaConsumerService.consumeEmailMessage(mockRecord);

        // Then
        verify(kafkaTranslatorInterface).translateEmailKafkaMessage(messageBytes);
        verify(apiIntegrationInterface).sendEmailMessageToIntegrationApi(mockEmailRequest);
    }

 @Test
    void shouldConsumeLetterMessageSuccessfully() {
        // Given
        byte[] messageBytes = "valid-letter-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>(LETTER_TOPIC, 0, 0, "key", messageBytes);

        Object mockLetterRequest = new Object(); // Replace with actual LetterRequest type
        when(kafkaTranslatorInterface.translateLetterKafkaMessage(messageBytes)).thenReturn(mockLetterRequest);

        // When
        kafkaConsumerService.consumeLetterMessage(mockRecord);

        // Then
        verify(kafkaTranslatorInterface).translateLetterKafkaMessage(messageBytes);
        verify(apiIntegrationInterface).sendLetterMessageToIntegrationApi(mockLetterRequest);
    }

    @Test
    void shouldNotCallApiIntegrationForNullEmailMessage() {
        // Given
        byte[] messageBytes = null;
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("email-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateEmailKafkaMessage(null)).thenReturn(null);

        // When
        kafkaConsumerService.consumeEmailMessage(mockRecord);

        // Then
        verify(kafkaTranslatorInterface).translateEmailKafkaMessage(null);
        verifyNoInteractions(apiIntegrationInterface);
    }

    @Test
    void shouldNotCallApiIntegrationForNullLetterMessage() {
        // Given
        byte[] messageBytes = null;
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("letter-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateLetterKafkaMessage(null)).thenReturn(null);

        // When
        kafkaConsumerService.consumeLetterMessage(mockRecord);

        // Then
        verify(kafkaTranslatorInterface).translateLetterKafkaMessage(null);
        verifyNoInteractions(apiIntegrationInterface);
    }

    @Test
    void shouldHandleExceptionDuringEmailMessageProcessing() {
        // Given
        byte[] messageBytes = "faulty-email-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("email-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateEmailKafkaMessage(messageBytes))
                .thenThrow(new RuntimeException("Translation failed"));

        // When & Then
        assertThrows(RuntimeException.class, () -> kafkaConsumerService.consumeEmailMessage(mockRecord));

        verify(kafkaTranslatorInterface).translateEmailKafkaMessage(messageBytes);
        verifyNoInteractions(apiIntegrationInterface);
    }

    @Test
    void shouldHandleExceptionDuringLetterMessageProcessing() {
        // Given
        byte[] messageBytes = "faulty-letter-message".getBytes();
        ConsumerRecord<String, byte[]> mockRecord = new ConsumerRecord<>("letter-topic", 0, 0, "key", messageBytes);

        when(kafkaTranslatorInterface.translateLetterKafkaMessage(messageBytes))
                .thenThrow(new RuntimeException("Translation failed"));

        // When & Then
        assertThrows(RuntimeException.class, () -> kafkaConsumerService.consumeLetterMessage(mockRecord));

        verify(kafkaTranslatorInterface).translateLetterKafkaMessage(messageBytes);
        verifyNoInteractions(apiIntegrationInterface);
    }*/
}
