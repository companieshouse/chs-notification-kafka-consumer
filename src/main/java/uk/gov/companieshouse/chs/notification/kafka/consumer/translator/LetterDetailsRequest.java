package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import uk.gov.companieshouse.api.chs_notification_sender.model.LetterDetails;
import uk.gov.companieshouse.api.chs_notification_sender.model.RecipientDetailsLetter;
import uk.gov.companieshouse.api.chs_notification_sender.model.SenderDetails;

@Validated
record LetterDetailsRequest(
    @NotNull
    SenderDetails senderDetails,

    @NotNull
    RecipientDetailsLetter recipientDetails,

    @NotNull
    LetterDetails letterDetails,

    @NotBlank()
    String createdAt
) {
}