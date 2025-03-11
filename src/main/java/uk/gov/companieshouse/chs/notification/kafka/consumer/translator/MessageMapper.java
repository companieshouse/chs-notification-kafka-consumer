package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;

@Component
@Mapper(componentModel = "spring")
interface MessageMapper {

    MessageMapper INSTANCE = Mappers.getMapper(MessageMapper.class);

     GovUkEmailDetailsRequest mapToEmailDetailsRequest(EmailDetailsRequest emailDetailsRequest);

    GovUkLetterDetailsRequest mapToLetterDetailsRequest(LetterDetailsRequest letterDetailsRequest);

}
