package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.beans.factory.annotation.Value;
import uk.gov.companieshouse.api.InternalApiClient;
import uk.gov.companieshouse.sdk.manager.ApiSdkManager;

public class ApiIntegrationController implements ApiIntegrationInterface {


    @Value("${chs-gov-uk-notify-integration-api}")
    String notificationApiUrl;

    @Override
    public InternalApiClient getNotificationApiUrl() {
        InternalApiClient notificationApiClient = ApiSdkManager.getPrivateSDK();
        notificationApiClient.setInternalBasePath(notificationApiUrl);
        notificationApiClient.setBasePath(notificationApiUrl);
        return notificationApiClient;
    }


}
