//package uk.gov.companieshouse.chs.notification.kafka.consumer.apiintegration;
//
//import org.springframework.stereotype.Service;
//import uk.gov.companieshouse.api.handler.payment.PrivatePaymentResourceHandler;
//
//import java.net.URI;
//import java.net.http.HttpClient;
//import java.net.http.HttpRequest;
//import java.net.http.HttpResponse;
//import java.net.http.HttpRequest;
//
//@Service
//public class ApiIntegrationService {
//
////ResourceHandler would be the best option to consider look up:
////PrivatePaymentResourceHandler
////below using java generic http builder
//
//    public ApiIntegrationService(ApiIntegrationController apiIntegrationController) {
//        this.apiIntegrationController = apiIntegrationController;
//    }
//
//    ApiIntegrationController apiIntegrationController;
//
//    public void sendEmail(GovUKEmailRequest govUKEmailRequest, id) {
//        String url = apiIntegrationController.getNotificationApiUrl() + "/email/" + id;
//        HttpClient client = HttpClient.newHttpClient();
//        HttpRequest request = HttpRequest.newBuilder()
//                .uri(new URI(url))
//                .header("Content-Type", "application/json")
//                .POST(HttpRequest.BodyPublishers.ofString("{\"key\":\"value\"}"))
//                .build();
//
//        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
//    }
//
//    public void sendLetter(GovUkLetterRequest govUkLetterRequest) {
//        String url = apiIntegrationController.getNotificationApiUrl() + "/letter" + id;
//        HttpClient client = HttpClient.newHttpClient();
//        HttpRequest request = HttpRequest.newBuilder()
//                .uri(new URI(url))
//                .header("Content-Type", "application/json")
//                .POST(HttpRequest.BodyPublishers.ofString("{\"key\":\"value\"}"))
//                .build();
//
//        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
//    }
//}
