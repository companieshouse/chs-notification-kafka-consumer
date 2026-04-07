package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import uk.gov.companieshouse.api.chs.notification.integration.model.EmailRequest;
import uk.gov.companieshouse.api.chs.notification.integration.model.LetterRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@ExtendWith(SpringExtension.class)
@SpringBootTest
class MessageMapperTest {
    private static final String APP_ID = "app123";
    private static final String REFERENCE = "ref123";

    @Autowired
    private MessageMapper messageMapper;

    @Test
    void When_MappingCompleteChsEmailNotification_Expect_AllFieldsMappedCorrectly() {
        // Arrange
        ChsEmailNotification chsEmailNotification = new ChsEmailNotification(APP_ID, REFERENCE);

        // Act
        EmailRequest result = messageMapper.mapToEmailRequest(chsEmailNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");
        assertEquals(APP_ID, result.getAppId(), "App ID should match");
        assertEquals(REFERENCE, result.getReference(), "Reference should match");
    }

    @Test
    void When_MappingCompleteChsLetterNotification_Expect_AllFieldsMappedCorrectly() {
        // Arrange
        ChsLetterNotification chsLetterNotification = new ChsLetterNotification(APP_ID, REFERENCE);

        // Act
        LetterRequest result = messageMapper.mapToLetterRequest(chsLetterNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");
        assertEquals(APP_ID, result.getAppId(), "App ID should match");
        assertEquals(REFERENCE, result.getReference(), "Reference should match");
    }

}
