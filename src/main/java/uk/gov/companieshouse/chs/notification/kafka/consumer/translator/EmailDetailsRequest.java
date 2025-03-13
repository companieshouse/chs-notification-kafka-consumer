package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import uk.gov.companieshouse.api.chs_notification_sender.model.EmailDetails;
import uk.gov.companieshouse.api.chs_notification_sender.model.RecipientDetailsEmail;
import uk.gov.companieshouse.api.chs_notification_sender.model.SenderDetails;



@Validated
record EmailDetailsRequest(
    @NotNull
    SenderDetails senderDetails,

    @NotNull
    RecipientDetailsEmail recipientDetails,

    @NotNull
    EmailDetails emailDetails,

    @NotBlank()
    String createdAt
) {
}
