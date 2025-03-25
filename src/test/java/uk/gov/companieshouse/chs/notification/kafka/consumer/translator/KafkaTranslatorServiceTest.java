package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import consumer.deserialization.AvroDeserializer;
import consumer.exception.NonRetryableErrorException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
public class KafkaTranslatorServiceTest {

    private static final String EMAIL_TOPIC = "chs-notification-email";
    private static final String LETTER_TOPIC = "chs-notification-letter";

    @Mock
    private AvroDeserializer<ChsEmailNotification> emailAvroDeserializer;

    @Mock
    private AvroDeserializer<ChsLetterNotification> letterAvroDeserializer;

    @Mock
    private MessageMapper messageMapper;

    @InjectMocks
    private KafkaTranslatorService kafkaTranslatorService;

    @BeforeEach
    void setUp() {
        kafkaTranslatorService = new KafkaTranslatorService(EMAIL_TOPIC, LETTER_TOPIC, emailAvroDeserializer, letterAvroDeserializer, messageMapper);
    }

    @Test
    void testEmailKafkaMessageDeserialization() {
        ChsEmailNotification chsEmailNotification = new ChsEmailNotification();
        GovUkEmailDetailsRequest mappedRequest = mock(GovUkEmailDetailsRequest.class);
        byte[] emailMessage = new byte[]{1, 2, 3};

        when(emailAvroDeserializer.deserialize(EMAIL_TOPIC, emailMessage)).thenReturn(chsEmailNotification);
        when(messageMapper.mapToEmailDetailsRequest(chsEmailNotification)).thenReturn(mappedRequest);

        GovUkEmailDetailsRequest deSerialisedMessage = kafkaTranslatorService.translateEmailKafkaMessage(emailMessage);

        verify(messageMapper, times(1)).mapToEmailDetailsRequest(chsEmailNotification);
        verify(emailAvroDeserializer, times(1)).deserialize(EMAIL_TOPIC, emailMessage);
        assertEquals(mappedRequest, deSerialisedMessage);
    }

    @Test
    void testLetterKafkaMessageDeserialization() {
        ChsLetterNotification chsLetterNotification = new ChsLetterNotification();
        GovUkLetterDetailsRequest mappedRequest = mock(GovUkLetterDetailsRequest.class);
        byte[] letterMessage = new byte[]{1, 2, 3};

        when(letterAvroDeserializer.deserialize(LETTER_TOPIC, letterMessage)).thenReturn(chsLetterNotification);
        when(messageMapper.mapToLetterDetailsRequest(chsLetterNotification)).thenReturn(mappedRequest);

        GovUkLetterDetailsRequest deSerialisedMessage = kafkaTranslatorService.translateLetterKafkaMessage(letterMessage);

        verify(messageMapper, times(1)).mapToLetterDetailsRequest(chsLetterNotification);
        verify(letterAvroDeserializer, times(1)).deserialize(LETTER_TOPIC, letterMessage);
        assertEquals(mappedRequest, deSerialisedMessage);
    }

    @Test
    void testEmailKafkaMessageDeserializationThrowsException() {
        ChsEmailNotification chsEmailNotification = new ChsEmailNotification();
        byte[] emailMessage = new byte[]{1, 2, 3};

        when(emailAvroDeserializer.deserialize(EMAIL_TOPIC, emailMessage)).thenReturn(chsEmailNotification);

        doThrow(new NonRetryableErrorException("Invalid message format"))
                .when(messageMapper).mapToEmailDetailsRequest(chsEmailNotification);

        assertThrows(NonRetryableErrorException.class, () -> kafkaTranslatorService.translateEmailKafkaMessage(emailMessage));
        verify(messageMapper, times(1)).mapToEmailDetailsRequest(chsEmailNotification);
    }

    @Test
    void testLetterKafkaMessageDeserializationThrowsException() {
        ChsLetterNotification chsLetterNotification = new ChsLetterNotification();
        byte[] letterMessage = new byte[]{1, 2, 3};

        when(letterAvroDeserializer.deserialize(LETTER_TOPIC, letterMessage)).thenReturn(chsLetterNotification);
        doThrow(new NonRetryableErrorException("Invalid message format"))
                .when(messageMapper).mapToLetterDetailsRequest(chsLetterNotification);

        assertThrows(NonRetryableErrorException.class, () -> kafkaTranslatorService.translateLetterKafkaMessage(letterMessage));
        verify(messageMapper, times(1)).mapToLetterDetailsRequest(chsLetterNotification);
    }
}
