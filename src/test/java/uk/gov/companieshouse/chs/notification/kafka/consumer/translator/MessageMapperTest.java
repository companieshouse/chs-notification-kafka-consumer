package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

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
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.LetterDetails;
import uk.gov.companieshouse.api.chs.notification.model.RecipientDetailsEmail;
import uk.gov.companieshouse.api.chs.notification.model.RecipientDetailsLetter;
import uk.gov.companieshouse.api.chs.notification.model.SenderDetails;
import uk.gov.companieshouse.notification.Address;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

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
        String timestamp = null;
        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");
        // Name, userId, and emailAddress remain null

        uk.gov.companieshouse.notification.RecipientDetailsEmail avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsEmail();
        avroRecipientDetails.setName("Recipient Name");
        avroRecipientDetails.setEmailAddress("recipient@example.com");

        uk.gov.companieshouse.notification.EmailDetails avroEmailDetails = new uk.gov.companieshouse.notification.EmailDetails();
        avroEmailDetails.setTemplateId("template123");
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
        assertNull(result.getCreatedAt(), "CreatedAt should be null");

        // Test sender details mapping
        SenderDetails senderDetails = result.getSenderDetails();
        assertNotNull(senderDetails, "Sender details should not be null");
        assertEquals("app123", senderDetails.getAppId(), "App ID should match");
        assertEquals("ref123", senderDetails.getReference(), "Reference should match");
        assertNull(senderDetails.getName(), "Name should be null");
        assertNull(senderDetails.getUserId(), "User ID should be null");
        assertNull(senderDetails.getEmailAddress(), "Email address should be null");

        // Test recipient details mapping
        RecipientDetailsEmail recipientDetails = result.getRecipientDetails();
        assertNotNull(recipientDetails, "Recipient details should not be null");
        assertEquals("Recipient Name", recipientDetails.getName(), "Recipient name should match");
        assertEquals("recipient@example.com", recipientDetails.getEmailAddress(), "Recipient email should match");

        // Test email details mapping
        EmailDetails emailDetails = result.getEmailDetails();
        assertNotNull(emailDetails, "Email details should not be null");
        assertEquals("template123", emailDetails.getTemplateId(), "Template ID should match");
        assertEquals("{\"key\":\"value\"}", emailDetails.getPersonalisationDetails(), "Personalisation details should match");
    }

    @Test
    void When_MappingCompleteChsLetterNotification_Expect_AllFieldsMappedCorrectly() {
        // Arrange
        String timestamp = null;
        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");
        avroSenderDetails.setName("Sender Name");
        avroSenderDetails.setUserId("user123");
        avroSenderDetails.setEmailAddress("sender@example.com");

        uk.gov.companieshouse.notification.RecipientDetailsLetter avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsLetter();
        avroRecipientDetails.setName("Recipient Name");
        Address address = new Address("line_1", "line_2", "line_3", "line_4", "line_5", "line_6", "line_7");
        avroRecipientDetails.setPhysicalAddress(address);

        uk.gov.companieshouse.notification.LetterDetails avroLetterDetails = new uk.gov.companieshouse.notification.LetterDetails();
        avroLetterDetails.setTemplateId("template123");
        avroLetterDetails.setLetterId("letter123");
        avroLetterDetails.setPersonalisationDetails("{\"key\":\"value\"}");

        ChsLetterNotification chsLetterNotification = new ChsLetterNotification(
                avroSenderDetails,
                avroRecipientDetails,
                avroLetterDetails,
                timestamp
        );

        // Act
        GovUkLetterDetailsRequest result = messageMapper.mapToLetterDetailsRequest(chsLetterNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");

        // Test createdAt mapping
        assertNull(result.getCreatedAt(), "CreatedAt should be null");

        // Test sender details mapping
        SenderDetails senderDetails = result.getSenderDetails();
        assertNotNull(senderDetails, "Sender details should not be null");
        assertEquals("app123", senderDetails.getAppId(), "App ID should match");
        assertEquals("ref123", senderDetails.getReference(), "Reference should match");
        assertEquals("Sender Name", senderDetails.getName(), "Name should match");
        assertEquals("user123", senderDetails.getUserId(), "User ID should match");
        assertEquals("sender@example.com", senderDetails.getEmailAddress(), "Email address should match");

        // Test recipient details mapping
        RecipientDetailsLetter recipientDetails = result.getRecipientDetails();
        assertNotNull(recipientDetails, "Recipient details should not be null");
        assertEquals("Recipient Name", recipientDetails.getName(), "Recipient name should match");
        assertEquals(address.getAddressLine1(), recipientDetails.getPhysicalAddress().getAddressLine1(), "Physical address line 1 should match");
        assertEquals(address.getAddressLine2(), recipientDetails.getPhysicalAddress().getAddressLine2(), "Physical address line 2 should match");
        assertEquals(address.getAddressLine3(), recipientDetails.getPhysicalAddress().getAddressLine3(), "Physical address line 3 should match");
        assertEquals(address.getAddressLine4(), recipientDetails.getPhysicalAddress().getAddressLine4(), "Physical address line 4 should match");
        assertEquals(address.getAddressLine5(), recipientDetails.getPhysicalAddress().getAddressLine5(), "Physical address line 5 should match");
        assertEquals(address.getAddressLine6(), recipientDetails.getPhysicalAddress().getAddressLine6(), "Physical address line 6 should match");

        // Test letter details mapping
        LetterDetails letterDetails = result.getLetterDetails();
        assertNotNull(letterDetails, "Email details should not be null");
        assertEquals("template123", letterDetails.getTemplateId(), "Template ID should match");
        assertEquals("letter123", letterDetails.getLetterId(), "Letter ID should match");
        assertEquals("{\"key\":\"value\"}", letterDetails.getPersonalisationDetails(), "Personalisation details should match");
    }

    @Test
    void When_MappingChsLetterNotificationWithNullOptionalFields_Expect_NullValuesInResult() {
        // Arrange
        String timestamp = "2023-05-01T14:30:00Z";
        uk.gov.companieshouse.notification.SenderDetails avroSenderDetails = new uk.gov.companieshouse.notification.SenderDetails();
        avroSenderDetails.setAppId("app123");
        avroSenderDetails.setReference("ref123");
        // Name, userId, and emailAddress remain null

        uk.gov.companieshouse.notification.RecipientDetailsLetter avroRecipientDetails = new uk.gov.companieshouse.notification.RecipientDetailsLetter();
        avroRecipientDetails.setName("Recipient Name");
        Address address = new Address("line_1", "line_2", "line_3", "line_4", "line_5", "line_6", "line_7");
        avroRecipientDetails.setPhysicalAddress(address);

        uk.gov.companieshouse.notification.LetterDetails avroLetterDetails = new uk.gov.companieshouse.notification.LetterDetails();
        avroLetterDetails.setTemplateId("template123");
        // Letter id remain null
        avroLetterDetails.setPersonalisationDetails("{\"key\":\"value\"}");

        ChsLetterNotification chsLetterNotification = new ChsLetterNotification(
                avroSenderDetails,
                avroRecipientDetails,
                avroLetterDetails,
                timestamp
        );

        // Act
        GovUkLetterDetailsRequest result = messageMapper.mapToLetterDetailsRequest(chsLetterNotification);

        // Assert
        assertNotNull(result, "Mapped result should not be null");


        // Test createdAt mapping
        OffsetDateTime expectedDateTime = OffsetDateTime.ofInstant(Instant.parse(timestamp), ZoneOffset.UTC);
        assertEquals(expectedDateTime, result.getCreatedAt(), "Created date/time should be correctly mapped");
        
        // Test sender details with null values
        SenderDetails senderDetails = result.getSenderDetails();
        assertNotNull(senderDetails, "Sender details should not be null");
        assertEquals("app123", senderDetails.getAppId(), "App ID should match");
        assertEquals("ref123", senderDetails.getReference(), "Reference should match");
        assertNull(senderDetails.getName(), "Name should be null");
        assertNull(senderDetails.getUserId(), "User ID should be null");
        assertNull(senderDetails.getEmailAddress(), "Email address should be null");

        // Test recipient details mapping
        RecipientDetailsLetter recipientDetails = result.getRecipientDetails();
        assertNotNull(recipientDetails, "Recipient details should not be null");
        assertEquals("Recipient Name", recipientDetails.getName(), "Recipient name should match");
        assertEquals(address.getAddressLine1(), recipientDetails.getPhysicalAddress().getAddressLine1(), "Physical address line 1 should match");
        assertEquals(address.getAddressLine2(), recipientDetails.getPhysicalAddress().getAddressLine2(), "Physical address line 2 should match");
        assertEquals(address.getAddressLine3(), recipientDetails.getPhysicalAddress().getAddressLine3(), "Physical address line 3 should match");
        assertEquals(address.getAddressLine4(), recipientDetails.getPhysicalAddress().getAddressLine4(), "Physical address line 4 should match");
        assertEquals(address.getAddressLine5(), recipientDetails.getPhysicalAddress().getAddressLine5(), "Physical address line 5 should match");
        assertEquals(address.getAddressLine6(), recipientDetails.getPhysicalAddress().getAddressLine6(), "Physical address line 6 should match");

        // Test letter details mapping
        LetterDetails letterDetails = result.getLetterDetails();
        assertNotNull(letterDetails, "Email details should not be null");
        assertEquals("template123", letterDetails.getTemplateId(), "Template ID should match");
        assertNull(letterDetails.getLetterId(), "Letter ID should be null");
        assertEquals("{\"key\":\"value\"}", letterDetails.getPersonalisationDetails(), "Personalisation details should match");
    }

}
