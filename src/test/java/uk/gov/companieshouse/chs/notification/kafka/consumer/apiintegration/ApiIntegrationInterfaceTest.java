package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
@Tag("unit-test")
public class ApiIntegrationInterfaceTest {

    @Autowired
    private NotifyIntegrationService notifyIntegrationService;

    @ParameterizedTest(name = "When email request is {0} and callback is {1}, exception should be thrown")
    @CsvSource({
            "null, valid",
            "null, null",
            "valid, null"
    })
    public void testEmailRequestValidation(String requestState, String callbackState) {
        GovUkEmailDetailsRequest request = "null".equals(requestState) ? null : new GovUkEmailDetailsRequest();
        Runnable callback = "null".equals(callbackState) ? null : () -> {};

        assertThrows(ConstraintViolationException.class, () ->
                notifyIntegrationService.sendEmailMessageToIntegrationApi(request, callback)
        );
    }

    @ParameterizedTest(name = "When letter request is {0} and callback is {1}, exception should be thrown")
    @CsvSource({
            "null, valid",
            "null, null",
            "valid, null"
    })
    public void testLetterRequestValidation(String requestState, String callbackState) {
        GovUkLetterDetailsRequest request = "null".equals(requestState) ? null : new GovUkLetterDetailsRequest();
        Runnable callback = "null".equals(callbackState) ? null : () -> {};

        assertThrows(ConstraintViolationException.class, () ->
                notifyIntegrationService.sendLetterMessageToIntegrationApi(request, callback)
        );
    }
}
