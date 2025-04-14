package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Component
@Mapper(componentModel = "spring")
public interface MessageMapper {

    @Mapping(source = "createdAt", target = "createdAt", qualifiedByName = "instantToOffsetDateTime")
    GovUkEmailDetailsRequest mapToEmailDetailsRequest(ChsEmailNotification chsEmailNotification);

    @Mapping(source = "createdAt", target = "createdAt", qualifiedByName = "instantToOffsetDateTime")
    GovUkLetterDetailsRequest mapToLetterDetailsRequest(ChsLetterNotification chsLetterNotification);

    @Named("instantToOffsetDateTime")
    static OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? OffsetDateTime.ofInstant(instant, ZoneOffset.UTC) : null;
    }
}
