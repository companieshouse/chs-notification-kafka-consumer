package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import org.mapstruct.Mapper;
import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs.notification.integration.model.EmailRequest;
import uk.gov.companieshouse.api.chs.notification.integration.model.LetterRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Component
@Mapper(componentModel = "spring")
public interface MessageMapper {

    EmailRequest mapToEmailRequest(ChsEmailNotification chsEmailNotification);

    LetterRequest mapToLetterRequest(ChsLetterNotification chsLetterNotification);

}
