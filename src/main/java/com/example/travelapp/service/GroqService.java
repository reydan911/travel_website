package com.example.travelapp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

@Service
public class GroqService {

    private static final Logger log = LoggerFactory.getLogger(GroqService.class);

    @Value("${groq.api.key}")
    private String apiKey;

    @Value("${groq.model:llama3-8b-8192}")
    private String model;

    // Groq is OpenAI-compatible
    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";

    /**
     * Generates text using Groq Chat Completions.
     * can use it for recommendations, itineraries, chat replies, etc.
     */
    @SuppressWarnings({"rawtypes", "unchecked"})
    public String generate(String userPrompt) {
        return generate(userPrompt, 0.7, null);
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    public String generateJson(String userPrompt) {
        return generate(userPrompt, 0.0, Map.of("type", "json_object"));
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private String generate(String userPrompt, double temperature, Map<String, Object> responseFormat) {
        try {
            if (apiKey == null || apiKey.isBlank()) {
                return "Groq error: Missing groq.api.key configuration.";
            }

            RestTemplate rest = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            Map<String, Object> body = new HashMap<>();
            body.put("model", model);
            body.put("temperature", temperature);

            if (responseFormat != null && !responseFormat.isEmpty()) {
                body.put("response_format", responseFormat);
            }

            List<Map<String, String>> messages = List.of(
                Map.of("role", "system", "content", "You are a helpful travel assistant. Follow the user's requested format."),
                Map.of("role", "user", "content", userPrompt)
            );

            body.put("messages", messages);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<Map> response = rest.postForEntity(API_URL, entity, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Object choicesObj = response.getBody().get("choices");
                if (choicesObj instanceof List<?> choices && !choices.isEmpty()) {
                    Object firstObj = choices.get(0);
                    if (firstObj instanceof Map<?, ?> first) {
                        Object messageObj = first.get("message");
                        if (messageObj instanceof Map<?, ?> message) {
                            Object contentObj = message.get("content");
                            if (contentObj != null) return String.valueOf(contentObj);
                        }
                    }
                }
            }

            return "Groq returned no content.";
        } catch (HttpStatusCodeException e) {
            String body = e.getResponseBodyAsString();
            log.warn("Groq error {}: {}", e.getStatusCode().value(), body);
            String summary = summarize(body);
            if (!summary.isBlank()) {
                return "Groq error: HTTP " + e.getStatusCode().value() + " - " + summary;
            }
            return "Groq error: HTTP " + e.getStatusCode().value();
        } catch (Exception e) {
            log.warn("Groq error", e);
            return "Groq error: " + e.getMessage();
        }
    }

    private static String summarize(String text) {
        if (text == null) return "";
        String trimmed = text.trim();
        if (trimmed.isEmpty()) return "";
        if (trimmed.length() > 300) {
            return trimmed.substring(0, 300) + "...";
        }
        return trimmed;
    }
}
