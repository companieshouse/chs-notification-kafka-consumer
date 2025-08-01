package helpers.utils;


import com.fasterxml.jackson.databind.JsonNode;
import helpers.OutputCapture;
import org.junit.jupiter.api.Assertions;

public class OutputAssertions {

    /**
     * Helper to extract the “data” object from a captured log entry.
     *
     * @param capture the OutputCapture instance containing the logs
     * @param event   the log level/event name (“debug”, “info”, “error”, etc.)
     * @return the “data” JsonNode for that entry
     * @throws AssertionError if the entry or its “data” field is missing
     */
    public static JsonNode getDataFromLogMessage(OutputCapture capture, String event,
            String message) {
        var entries = capture.getJsonEntries();
        if (entries.isEmpty()) {
            throw new AssertionError("No log entries found for event: " + event);
        }
        var matchingEventEntries = entries.stream()
                .filter(e -> e.has("event") && event.equals(e.get("event").asText()))
                .filter(e -> e.has("data") && e.get("data").has("message"))
                .map(e -> e.get("data"))
                .toList();

        if (matchingEventEntries.isEmpty()) {
            throw new AssertionError(
                    "No log entries found for event: '" + event + "' with a 'data.message' field.");
        }

        System.out.println();
        System.out.println("--------------------------");
        System.out.println(matchingEventEntries);

        return matchingEventEntries.stream()
                .filter(e -> message.equals(e.get("message").asText()))
                .findFirst()
                .orElseThrow(() -> {
                    String actualMessages = matchingEventEntries.stream()
                            .map(e -> e.get("message").asText())
                            .distinct()
                            .reduce((a, b) -> a + "\n" + b)
                            .orElse("[no messages found]");
                    return new AssertionError(
                            "No log entry found with message:\n  Expected: " + message
                                    + "\n  Found:    " + actualMessages);
                });
    }

    /**
     * Helper to assert that a JSON node has a specific field and that the field's value matches the
     * expected value.
     *
     * @param jsonNode      the JsonNode to check
     * @param fieldName     the name of the field to check
     * @param expectedValue the expected value of the field
     */
    public static void assertJsonHasAndEquals(JsonNode jsonNode, String fieldName,
            String expectedValue) {
        Assertions.assertNotNull(jsonNode,
                "JSON node for field '" + fieldName + "' should not be null");
        Assertions.assertTrue(jsonNode.has(fieldName), "JSON should contain field: " + fieldName);
        Assertions.assertEquals(expectedValue, jsonNode.get(fieldName).asText(),
                "Field '" + fieldName + "' should match expected");
    }
}
