package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import uk.gov.companieshouse.api.chs.notification.model.EmailDetails;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.RecipientDetailsEmail;
import uk.gov.companieshouse.api.chs.notification.model.SenderDetails;
import uk.gov.companieshouse.notification.ChsEmailNotification;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

@ExtendWith(SpringExtension.class)
@SpringBootTest
class MessageMapperTest {

    @Autowired
    private MessageMapper messageMapper;

    @Test
    void When_MappingCompleteChsEmailNotification_Expect_AllFieldsMappedCorrectly() {
        // Arrange
        String timestamp = "2023-05-01T14:30:00Z";
        OffsetDateTime expectedDateTime = OffsetDateTime.ofInstant(Instant.parse(timestamp), ZoneOffset.UTC);

        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");
        avroSenderDetails.setName("Sender Name");
        avroSenderDetails.setUserId("user123");
        avroSenderDetails.setEmailAddress("sender@example.com");

        uk.gov.companieshouse.notification.RecipientDetailsEmail avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsEmail();
        avroRecipientDetails.setName("Recipient Name");
        avroRecipientDetails.setEmailAddress("recipient@example.com");

        uk.gov.companieshouse.notification.EmailDetails avroEmailDetails = new uk.gov.companieshouse.notification.EmailDetails();
        avroEmailDetails.setTemplateId("template123");
        avroEmailDetails.setTemplateVersion(1.0);
        avroEmailDetails.setPersonalisationDetails("{\"key\":\"value\"}");

        ChsEmailNotification chsEmailNotification = new ChsEmailNotification(
                avroSenderDetails,
                avroRecipientDetails,
                avroEmailDetails,
                timestamp
        );

        // Act
        GovUkEmailDetailsRequest result = messageMapper.mapToEmailDetailsRequest(chsEmailNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");

        // Test createdAt mapping
        assertEquals(expectedDateTime, result.getCreatedAt(), "Created date/time should be correctly mapped");

        // Test sender details mapping
        SenderDetails senderDetails = result.getSenderDetails();
        assertNotNull(senderDetails, "Sender details should not be null");
        assertEquals("app123", senderDetails.getAppId(), "App ID should match");
        assertEquals("ref123", senderDetails.getReference(), "Reference should match");
        assertEquals("Sender Name", senderDetails.getName(), "Name should match");
        assertEquals("user123", senderDetails.getUserId(), "User ID should match");
        assertEquals("sender@example.com", senderDetails.getEmailAddress(), "Email address should match");

        // Test recipient details mapping
        RecipientDetailsEmail recipientDetails = result.getRecipientDetails();
        assertNotNull(recipientDetails, "Recipient details should not be null");
        assertEquals("Recipient Name", recipientDetails.getName(), "Recipient name should match");
        assertEquals("recipient@example.com", recipientDetails.getEmailAddress(), "Recipient email should match");

        // Test email details mapping
        EmailDetails emailDetails = result.getEmailDetails();
        assertNotNull(emailDetails, "Email details should not be null");
        assertEquals("template123", emailDetails.getTemplateId(), "Template ID should match");
        assertEquals(new BigDecimal("1.0"), emailDetails.getTemplateVersion(), "Template version should match");
        assertEquals("{\"key\":\"value\"}", emailDetails.getPersonalisationDetails(), "Personalisation details should match");
    }

    @Test
    void When_ConvertingValidDateTimeString_Expect_CorrectOffsetDateTime() {
        // Arrange
        String timestamp = "2023-05-01T14:30:00Z";
        OffsetDateTime expectedDateTime = OffsetDateTime.ofInstant(Instant.parse(timestamp), ZoneOffset.UTC);

        // Act
        OffsetDateTime result = MessageMapper.stringToOffsetDateTime(timestamp);

        // Assert
        assertEquals(expectedDateTime, result, "Date/time should be correctly converted");
    }

    @Test
    void When_ConvertingNullDateTimeString_Expect_NullResult() {
        // Act & Assert
        assertNull(MessageMapper.stringToOffsetDateTime(null), "Null input should result in null output");
    }

    @Test
    void When_MappingChsEmailNotificationWithNullOptionalFields_Expect_NullValuesInResult() {
        // Arrange
        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");
        // Name, userId, and emailAddress remain null

        uk.gov.companieshouse.notification.RecipientDetailsEmail avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsEmail();
        avroRecipientDetails.setName("Recipient Name");
        avroRecipientDetails.setEmailAddress("recipient@example.com");

        uk.gov.companieshouse.notification.EmailDetails avroEmailDetails = new uk.gov.companieshouse.notification.EmailDetails();
        avroEmailDetails.setTemplateId("template123");
        avroEmailDetails.setTemplateVersion(1.0);
        avroEmailDetails.setPersonalisationDetails("{\"key\":\"value\"}");

        ChsEmailNotification chsEmailNotification = new ChsEmailNotification(
                avroSenderDetails,
                avroRecipientDetails,
                avroEmailDetails,
                "2023-05-01T14:30:00Z"
        );

        // Act
        GovUkEmailDetailsRequest result = messageMapper.mapToEmailDetailsRequest(chsEmailNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");

        // Test sender details with null values
        SenderDetails senderDetails = result.getSenderDetails();
        assertNotNull(senderDetails, "Sender details should not be null");
        assertNull(senderDetails.getName(), "Name should be null");
        assertNull(senderDetails.getUserId(), "User ID should be null");
        assertNull(senderDetails.getEmailAddress(), "Email address should be null");
    }

    @Test
    void When_MappingChsEmailNotificationWithNullCreatedAt_Expect_NullCreatedAtInResult() {
        // Arrange
        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");

        uk.gov.companieshouse.notification.RecipientDetailsEmail avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsEmail();
        avroRecipientDetails.setName("Recipient Name");
        avroRecipientDetails.setEmailAddress("recipient@example.com");

        uk.gov.companieshouse.notification.EmailDetails avroEmailDetails = new uk.gov.companieshouse.notification.EmailDetails();
        avroEmailDetails.setTemplateId("template123");
        avroEmailDetails.setTemplateVersion(1.0);
        avroEmailDetails.setPersonalisationDetails("{\"key\":\"value\"}");

        ChsEmailNotification chsEmailNotification = new ChsEmailNotification(
                avroSenderDetails,
                avroRecipientDetails,
                avroEmailDetails,
                null // null createdAt
        );

        // Act
        GovUkEmailDetailsRequest result = messageMapper.mapToEmailDetailsRequest(chsEmailNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");
        assertNull(result.getCreatedAt(), "CreatedAt should be null");
    }
}
