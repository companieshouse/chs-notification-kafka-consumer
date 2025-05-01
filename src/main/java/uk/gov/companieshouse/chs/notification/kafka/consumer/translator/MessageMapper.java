package uk.gov.companieshouse.chs.notification.kafka.consumer.translator;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.springframework.stereotype.Component;
import uk.gov.companieshouse.api.chs.notification.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs.notification.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.notification.ChsEmailNotification;
import uk.gov.companieshouse.notification.ChsLetterNotification;

@Component
@Mapper(componentModel = "spring")
public interface MessageMapper {

    @Mapping(source = "createdAt", target = "createdAt", qualifiedByName = "stringToOffsetDateTime")
    GovUkEmailDetailsRequest mapToEmailDetailsRequest(ChsEmailNotification chsEmailNotification);

    @Mapping(source = "createdAt", target = "createdAt", qualifiedByName = "stringToOffsetDateTime")
    GovUkLetterDetailsRequest mapToLetterDetailsRequest(ChsLetterNotification chsLetterNotification);

    @Named("stringToOffsetDateTime")
    static OffsetDateTime stringToOffsetDateTime(String dateTime) {
        return dateTime != null ? OffsetDateTime.ofInstant(Instant.parse(dateTime), ZoneOffset.UTC) : null;
    }
}
