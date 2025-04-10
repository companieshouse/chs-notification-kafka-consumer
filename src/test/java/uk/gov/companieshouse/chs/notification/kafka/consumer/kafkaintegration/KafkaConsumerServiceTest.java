package uk.gov.companieshouse.chs.notification.kafka.consumer.kafkaintegration;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayNameGeneration;
import org.junit.jupiter.api.DisplayNameGenerator;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.support.Acknowledgment;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.ApiIntegrationInterface;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.MessageMapper;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
@DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
public class KafkaConsumerServiceTest {

    @Mock
    private MessageMapper messageMapper;

    @Mock
    private ApiIntegrationInterface apiIntegrationInterface;

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

    @BeforeEach
    void setUp() {
        mockEmailNotification = new ChsEmailNotification();
        mockLetterNotification = new ChsLetterNotification();
        mockEmailRequest = new GovUkEmailDetailsRequest();
        mockLetterRequest = new GovUkLetterDetailsRequest();
    }

    @Test
    void should_Consume_Email_Message_Successfully() {
        ConsumerRecord<String, ChsEmailNotification> record = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", mockEmailNotification);
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenReturn(mockEmailRequest);

        ArgumentCaptor<Runnable> runnableCaptor = ArgumentCaptor.forClass(Runnable.class);
        kafkaConsumerService.consumeEmailMessage(record, acknowledgment);

        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verify(apiIntegrationInterface).sendEmailMessageToIntegrationApi(
                eq(mockEmailRequest),
                runnableCaptor.capture()
        );

        runnableCaptor.getValue().run();
        verify(acknowledgment).acknowledge();
    }

    @Test
    void should_Consume_Letter_Message_Successfully() {
        ConsumerRecord<String, ChsLetterNotification> record = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", mockLetterNotification);
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenReturn(mockLetterRequest);

        ArgumentCaptor<Runnable> runnableCaptor = ArgumentCaptor.forClass(Runnable.class);
        kafkaConsumerService.consumeLetterMessage(record, acknowledgment);

        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verify(apiIntegrationInterface).sendLetterMessageToIntegrationApi(
                eq(mockLetterRequest),
                runnableCaptor.capture()
        );

        runnableCaptor.getValue().run();
        verify(acknowledgment).acknowledge();
    }

    @Test
    void should_Handle_Exception_During_Email_Message_Mapping() {
        ConsumerRecord<String, ChsEmailNotification> record = new ConsumerRecord<>(EMAIL_TOPIC, 0, 0L, "key", mockEmailNotification);
        when(messageMapper.mapToEmailDetailsRequest(mockEmailNotification)).thenThrow(new RuntimeException("Mapping failed"));

        assertThrows(RuntimeException.class, () -> kafkaConsumerService.consumeEmailMessage(record, acknowledgment));

        verify(messageMapper).mapToEmailDetailsRequest(mockEmailNotification);
        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }

    @Test
    void should_Handle_Exception_During_Letter_Message_Mapping() {
        ConsumerRecord<String, ChsLetterNotification> record = new ConsumerRecord<>(LETTER_TOPIC, 0, 0L, "key", mockLetterNotification);
        when(messageMapper.mapToLetterDetailsRequest(mockLetterNotification)).thenThrow(new RuntimeException("Mapping failed"));

        assertThrows(RuntimeException.class, () -> kafkaConsumerService.consumeLetterMessage(record, acknowledgment));

        verify(messageMapper).mapToLetterDetailsRequest(mockLetterNotification);
        verifyNoInteractions(apiIntegrationInterface);
        verify(acknowledgment, never()).acknowledge();
    }
}
