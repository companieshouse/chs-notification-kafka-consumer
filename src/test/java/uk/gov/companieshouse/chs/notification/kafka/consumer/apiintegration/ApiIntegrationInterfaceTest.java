package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.support.Acknowledgment;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
@Tag("unit-test")
public class ApiIntegrationInterfaceTest {

    @Autowired
    @Qualifier("apiIntegrationImpl")
    private ApiIntegrationInterface apiIntegration;

    @Mock
    private Acknowledgment acknowledgment;

    @ParameterizedTest(name = "When_EmailRequest{0}_And_Acknowledgment{1}_Expect_ExceptionToBeThrown")
    @CsvSource({
            "IsNull, IsValid",
            "IsNull, IsNull",
            "IsValid, IsNull"
    })
    public void When_EmailRequestAndAcknowledgmentCombinations_Expect_ExceptionToBeThrown(String requestState, String ackState) {
        GovUkEmailDetailsRequest request = "IsNull".equals(requestState) ? null : new GovUkEmailDetailsRequest();
        Acknowledgment ack = "IsNull".equals(ackState) ? null : acknowledgment;

        assertThrows(ConstraintViolationException.class, () -> {
            apiIntegration.sendEmailMessageToIntegrationApi(request, ack);
        });
    }

    @ParameterizedTest(name = "When_LetterRequest{0}_And_Acknowledgment{1}_Expect_ExceptionToBeThrown")
    @CsvSource({
            "IsNull, IsValid",
            "IsNull, IsNull",
            "IsValid, IsNull"
    })
    public void When_LetterRequestAndAcknowledgmentCombinations_Expect_ExceptionToBeThrown(String requestState, String ackState) {
        GovUkLetterDetailsRequest request = "IsNull".equals(requestState) ? null : new GovUkLetterDetailsRequest();
        Acknowledgment ack = "IsNull".equals(ackState) ? null : acknowledgment;

        assertThrows(ConstraintViolationException.class, () -> {
            apiIntegration.sendLetterMessageToIntegrationApi(request, ack);
        });
    }
}
