package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

import static org.junit.jupiter.api.Assertions.assertThrowsExactly;

@SpringBootTest
@Tag("unit-test")
class ApiIntegrationInterfaceTest {

    @Autowired
    private NotifyIntegrationService notifyIntegrationService;

    @Test
    void When_NullEmailRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendEmailMessageToIntegrationApi(null),
                "Should throw ConstraintViolationException for null email request");
    }

    @Test
    void When_EmptyEmailRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendEmailMessageToIntegrationApi(new GovUkEmailDetailsRequest()),
                "Should throw ConstraintViolationException for empty email request");
    }

    @Test
    void When_NullLetterRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendLetterMessageToIntegrationApi(null),
                "Should throw ConstraintViolationException for null letter request");
    }

    @Test
    void When_EmptyLetterRequest_Expect_ConstraintViolationException() {
        assertThrowsExactly(ConstraintViolationException.class,
                () -> notifyIntegrationService.sendLetterMessageToIntegrationApi(new GovUkLetterDetailsRequest()),
                "Should throw ConstraintViolationException for empty letter request");
    }
}
