//package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;
//
//import consumer.deserialization.AvroDeserializer;
//import email.SenderDetails;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Tag;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.jupiter.MockitoExtension;
//import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
//
//import static org.junit.jupiter.api.Assertions.*;
//import static org.mockito.Mockito.*;
//
//@ExtendWith(MockitoExtension.class)
//@Tag("unit-test")
//public class KafkaTranslatorServiceTest {
//
//    private static final String EMAIL_TOPIC = "chs-notification-email";
//    private static final String LETTER_TOPIC = "chs-notification-letter";
//
//    @Mock
//    private AvroDeserializer avroDeserializer;
//
//    @Mock
//    private MessageMapper messageMapper;
//
//    @InjectMocks
//    private KafkaTranslatorService kafkaTranslatorService;
//
//    @BeforeEach
//    void setUp() {
//        kafkaTranslatorService = new KafkaTranslatorService(EMAIL_TOPIC, LETTER_TOPIC, avroDeserializer, messageMapper);
//    }
//
//    @Test
//    void testTranslateEmailKafkaMessageToGovUkEmailRequest() throws Exception {
//        EmailDetailsRequest emailRequest = new EmailDetailsRequest();
//        GovUkEmailDetailsRequest mappedRequest = mock(GovUkEmailDetailsRequest.class);
//        byte[] serialisedData = new byte[]{1, 2, 3};
//
//        when(messageMapper.mapToEmailDetailsRequest(emailRequest)).thenReturn(mappedRequest);
//        when(mappedRequest.thenReturn(EmailDetailsRequest);
//        when(avroDeserializer.deserialize(EMAIL_TOPIC, serialisedData)).thenReturn(GovUkEmailDetailsRequest);
//
//        GovUkEmailDetailsRequest deserialisedMessage = kafkaTranslatorService.translateEmailKafkaMessage(serialisedData);
//
//        verify(messageMapper, times(1)).mapToEmailDetailsRequest(emailRequest);
//        verify(avroDeserializer, times(1)).deserialize(EMAIL_TOPIC, serialisedData);
//    }
//
//    @Test
//    public void testEmailKafkaMessageDeserialization() {
//        EmailDetailsRequest emailRequest = new EmailDetailsRequest(,"Reciepent","details","");
//        GovUkEmailDetailsRequest mappedRequest = mock(GovUkEmailDetailsRequest.class);
//        byte[] serialisedData = new byte[]{1, 2, 3};
//
//        when(messageMapper.mapToEmailDetailsRequest(emailRequest)).thenReturn(mappedRequest);
//        when(avroDeserializer.deserialize(EMAIL_TOPIC, serialisedData)).thenReturn(mappedRequest);
//
//        GovUkEmailDetailsRequest deSerialisedMessage = kafkaTranslatorService.translateEmailKafkaMessage(serialisedData);
//
//        verify(messageMapper, times(1)).mapToEmailDetailsRequest(emailRequest);
//        verify(avroDeserializer, times(1)).deserialize(EMAIL_TOPIC, serialisedData);
//        assertEquals(mappedRequest, deSerialisedMessage);
//    }
//}
//
////    @Test
////    void testTranslateEmailKafkaMessageToGovUkLetterRequest() throws Exception {
////        GovUkLetterDetailsRequest letterRequest = new GovUkLetterDetailsRequest();
////        LetterDetailsRequest mappedRequest = mock(LetterDetailsRequest.class);
////        String jsonMessage = "{\"message\":\"letter\"}";
////        byte[] expectedBytes = new byte[]{4, 5, 6};
////
////        when(notificationMapper.mapToLetterDetailsRequest(letterRequest)).thenReturn(mappedRequest);
////        when(mappedRequest.convertToJson()).thenReturn(jsonMessage);
////        when(avroSerializer.serialize(LETTER_TOPIC, jsonMessage)).thenReturn(expectedBytes);
////
////        byte[] result = kafkaTranslatorService.translateNotificationToLetterKafkaMessage(letterRequest);
////
////        assertArrayEquals(expectedBytes, result);
////        verify(notificationMapper, times(1)).mapToLetterDetailsRequest(letterRequest);
////        verify(avroSerializer, times(1)).serialize(LETTER_TOPIC, jsonMessage);
////    }
////
////    @Test
////    void testTranslateNotificationToEmailKafkaMessageThrowsException() {
////        GovUkEmailDetailsRequest emailRequest = new GovUkEmailDetailsRequest();
////
////        doThrow(new IllegalArgumentException("Invalid message format"))
////                .when(notificationMapper).mapToEmailDetailsRequest(emailRequest);
////
////        assertThrows(IllegalArgumentException.class, () -> kafkaTranslatorService.translateNotificationToEmailKafkaMessage(emailRequest));
////        verify(notificationMapper, times(1)).mapToEmailDetailsRequest(emailRequest);
////    }
////
////    @Test
////    void testTranslateNotificationToLetterKafkaMessageThrowsException() {
////        GovUkLetterDetailsRequest letterRequest = new GovUkLetterDetailsRequest();
////
////        doThrow(new IllegalArgumentException("Invalid message format"))
////                .when(notificationMapper).mapToLetterDetailsRequest(letterRequest);
////
////        assertThrows(IllegalArgumentException.class, () -> kafkaTranslatorService.translateNotificationToLetterKafkaMessage(letterRequest));
////        verify(notificationMapper, times(1)).mapToLetterDetailsRequest(letterRequest);
////    }
//}
