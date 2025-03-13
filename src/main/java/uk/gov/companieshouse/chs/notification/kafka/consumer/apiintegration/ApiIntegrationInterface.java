package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import uk.gov.companieshouse.api.InternalApiClient;

public interface ApiIntegrationInterface {
    public InternalApiClient getNotificationApiUrl();

}
