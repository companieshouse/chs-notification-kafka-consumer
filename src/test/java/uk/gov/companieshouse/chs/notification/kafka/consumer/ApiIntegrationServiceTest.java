package uk.gov.companieshouse.chs.notification.kafka.consumer;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration.ApiIntegrationService;
import uk.gov.companieshouse.chs.notification.kafka.consumer.translator.KafkaTranslatorInterface;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(MockitoExtension.class)
@Tag("unit-test")
class ApiIntegrationServiceTest {

    @Mock
    private KafkaTranslatorInterface kafkaTranslatorInterface;

    @InjectMocks
    private ApiIntegrationService apiIntegrationService;


    @Test
    @DisplayName("Translate Kafka Message to GovUkEmailDetails")
    void shouldTranslateEmailNotificationSuccessfully() {
        GovUkEmailDetailsRequest emailRequest = new GovUkEmailDetailsRequest();
        byte[] expectedByteMessage = new byte[]{1, 2, 3};

        when(kafkaTranslatorInterface.translateEmailKafkaMessage(expectedByteMessage)).thenReturn(emailRequest);

        GovUkEmailDetailsRequest result = apiIntegrationService.translateEmailKafkaMessage(expectedByteMessage);

        verify(kafkaTranslatorInterface, times(1)).translateEmailKafkaMessage(expectedByteMessage);
        assertEquals(expectedByteMessage,result);
    }

//    @Test
//    @DisplayName("Translate Kafka Message to GovUkEmailDetails")
//    void shouldTranslateLetterNotificationSuccessfully() {
//        GovUkLetterDetailsRequest letterDetailsRequest = new GovUkLetterDetailsRequest();
//        byte[] expectedBytes = new byte[]{1, 2, 3};
//
//        when(kafkaTranslatorInterface.translateLetterKafkaMessage(expectedBytes)).thenReturn(letterDetailsRequest);
//
//        GovUkLetterDetailsRequest result = apiIntegrationService.translateLetterKafkaMessage(expectedBytes);
//
//        verify(kafkaTranslatorInterface, times(1)).translateEmailKafkaMessage(result);
//    }

}
