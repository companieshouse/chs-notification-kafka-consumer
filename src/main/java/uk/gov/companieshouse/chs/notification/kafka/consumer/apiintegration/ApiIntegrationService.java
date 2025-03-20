package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;

import org.springframework.stereotype.Service;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkEmailDetailsRequest;
import uk.gov.companieshouse.api.chs_notification_sender.model.GovUkLetterDetailsRequest;
import uk.gov.companieshouse.api.handler.payment.PrivatePaymentResourceHandler;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
public class ApiIntegrationService {

//ResourceHandler would be the best option to consider look up:
//            PrivatePaymentResourceHandler?

    public ApiIntegrationService(ApiIntegrationController apiIntegrationController) {
        this.apiIntegrationController = apiIntegrationController;
    }

    ApiIntegrationController apiIntegrationController;


    public void sendEmail(GovUkEmailDetailsRequest govUkEmailDetailsRequest) {
        String url = apiIntegrationController.getNotificationApiUrl() + "/email/";
        HttpClient client = HttpClient.newHttpClient();

        try {
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(new URI(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString("{\"key\":\"value\"}"))
                    .build();

            HttpResponse<String> response = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendLetter(GovUkLetterDetailsRequest govUkLetterRequest) {
        String url = apiIntegrationController.getNotificationApiUrl() + "/letter/";
        HttpClient client = HttpClient.newHttpClient();

        try {
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(new URI(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString("{\"key\":\"value\"}"))
                    .build();

            HttpResponse<String> response = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
