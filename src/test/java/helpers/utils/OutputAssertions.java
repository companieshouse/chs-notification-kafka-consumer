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
     * @param index   which occurrence of that event to grab (0-based)
     * @return the “data” JsonNode for that entry
     * @throws AssertionError if the entry or its “data” field is missing
     */
    public static JsonNode getDataFromLog(OutputCapture capture, String event, int index) {
        JsonNode entry = capture.findEntryByEvent(event, index)
                .orElseThrow(() -> new AssertionError(
                        "Missing '" + event + "' log entry at index " + index));
        JsonNode data = entry.get("data");
        if (data == null) {
            throw new AssertionError(
                    "Missing 'data' field in '" + event + "' entry at index " + index);
        }
        return data;
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
