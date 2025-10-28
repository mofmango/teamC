package org.mnu.service;

import org.mnu.domain.NutritionVO;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import lombok.extern.log4j.Log4j;

import java.util.Optional;

@Log4j
@Service
public class NutritionServiceImpl implements NutritionService {

    // 기본 모델
    private static final String DEFAULT_MODEL = "gemini-1.5-pro";

    // Base URL
    private static final String BASE_URL = "https://generativelanguage.googleapis.com/v1beta";

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public NutritionVO getNutritionInfo(String ingredients) {

        NutritionVO nutritionVO = new NutritionVO();

        // ✅ 현재는 테스트용으로 직접 키 입력 (운영시엔 환경변수로 관리)
        String apiKeyOrBearer = "AIzaSyCZGw-6q9jPOkv6dw16B61-6B_XUR5fiBI";

        String modelToUse = DEFAULT_MODEL;
        boolean success = false;
        String generateResponse = null;

        try {
            generateResponse = callGenerateContent(modelToUse, ingredients, apiKeyOrBearer);
            success = (generateResponse != null);
        } catch (RestClientException ex) {
            log.warn("Primary model call failed for model=" + modelToUse + " : " + ex.getMessage());
        }

        // 404 등 실패 시 ListModels를 통해 사용 가능한 모델 재시도
        if (!success) {
            try {
                Optional<String> foundModel = findAvailableGeminiModel(apiKeyOrBearer);
                if (foundModel.isPresent()) {
                    modelToUse = foundModel.get();
                    log.info("Falling back to discovered model: " + modelToUse);
                    generateResponse = callGenerateContent(modelToUse, ingredients, apiKeyOrBearer);
                    success = (generateResponse != null);
                } else {
                    log.error("No suitable Gemini model found via ListModels");
                }
            } catch (Exception e) {
                log.error("Error while trying to list models or fallback: ", e);
            }
        }

        // 응답 파싱
        try {
            if (success && generateResponse != null) {
                JsonObject root = JsonParser.parseString(generateResponse).getAsJsonObject();

                // ✅ 1) Gemini 응답의 candidates → content → parts[0].text 구조 처리
                if (root.has("candidates")) {
                    JsonArray candidates = root.getAsJsonArray("candidates");
                    if (candidates.size() > 0) {
                        JsonObject first = candidates.get(0).getAsJsonObject();
                        if (first.has("content")) {
                            JsonObject content = first.getAsJsonObject("content");
                            if (content.has("parts")) {
                                JsonArray parts = content.getAsJsonArray("parts");
                                if (parts.size() > 0) {
                                    JsonObject part = parts.get(0).getAsJsonObject();
                                    if (part.has("text")) {
                                        String text = part.get("text").getAsString();

                                        // ✅ 백틱(```json ... ```) 제거
                                        text = text.replace("```json", "")
                                                   .replace("```", "")
                                                   .trim();

                                        // ✅ JSON 부분만 추출
                                        int start = text.indexOf('{');
                                        int end = text.lastIndexOf('}');
                                        if (start >= 0 && end > start) {
                                            String jsonPart = text.substring(start, end + 1);
                                            JsonObject nutritionJson = JsonParser.parseString(jsonPart).getAsJsonObject();
                                            fillNutritionFromJson(nutritionVO, nutritionJson);
                                            return nutritionVO;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ✅ 2) 혹시 바로 JSON 객체로 오는 경우
                if (root.has("calories") || root.has("protein") || root.has("carbohydrate")) {
                    fillNutritionFromJson(nutritionVO, root);
                    return nutritionVO;
                }

                log.error("Could not find nutrition JSON in model response. Raw response: " + generateResponse);
                return new NutritionVO();

            } else {
                log.error("GenerateContent did not return a successful response");
                return new NutritionVO();
            }
        } catch (Exception e) {
            log.error("Error calling or parsing Gemini API response", e);
            return new NutritionVO();
        }
    }

    // Gemini API 호출
    private String callGenerateContent(String model, String ingredients, String apiKeyOrBearer) {
        String url = BASE_URL + "/models/" + model + ":generateContent";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        boolean usedApiKeyQuery = false;

        if (apiKeyOrBearer != null && apiKeyOrBearer.startsWith("ya29")) {
            headers.setBearerAuth(apiKeyOrBearer);
        } else if (apiKeyOrBearer != null && apiKeyOrBearer.startsWith("AIza")) {
            url += "?key=" + apiKeyOrBearer;
            usedApiKeyQuery = true;
        } else {
            headers.setBearerAuth(apiKeyOrBearer);
        }

        String promptText = buildNutritionPrompt(ingredients);

        JsonObject part = new JsonObject();
        part.addProperty("text", promptText);

        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        parts.add(part);
        content.add("parts", parts);
        content.addProperty("role", "user");

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject body = new JsonObject();
        body.add("contents", contents);

        HttpEntity<String> entity = new HttpEntity<>(body.toString(), headers);

        try {
            return restTemplate.postForObject(url, entity, String.class);
        } catch (RestClientException ex) {
            if (!usedApiKeyQuery && apiKeyOrBearer != null && apiKeyOrBearer.startsWith("AIza")) {
                String urlWithKey = url + (url.contains("?") ? "&" : "?") + "key=" + apiKeyOrBearer;
                try {
                    return restTemplate.postForObject(urlWithKey, entity, String.class);
                } catch (RestClientException ex2) {
                    log.error("Second attempt (query API key) failed: " + ex2.getMessage(), ex2);
                    throw ex2;
                }
            }
            log.error("GenerateContent call failed: " + ex.getMessage(), ex);
            throw ex;
        }
    }

    // 모델 목록 조회
    private Optional<String> findAvailableGeminiModel(String apiKeyOrBearer) {
        String url = BASE_URL + "/models";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        if (apiKeyOrBearer != null && apiKeyOrBearer.startsWith("ya29")) {
            headers.setBearerAuth(apiKeyOrBearer);
        } else if (apiKeyOrBearer != null && apiKeyOrBearer.startsWith("AIza")) {
            url += "?key=" + apiKeyOrBearer;
        } else {
            headers.setBearerAuth(apiKeyOrBearer);
        }

        HttpEntity<String> entity = new HttpEntity<>("", headers);

        try {
            String resp = restTemplate.getForObject(url, String.class, entity);
            if (resp == null) return Optional.empty();

            JsonObject root = JsonParser.parseString(resp).getAsJsonObject();
            if (root.has("models")) {
                JsonArray models = root.getAsJsonArray("models");
                for (int i = 0; i < models.size(); i++) {
                    JsonObject m = models.get(i).getAsJsonObject();
                    if (m.has("name")) {
                        String name = m.get("name").getAsString();
                        if (name.contains("gemini") && name.contains("1.5")) {
                            if (name.startsWith("models/")) {
                                name = name.substring("models/".length());
                            }
                            return Optional.of(name);
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.warn("ListModels request failed: " + e.getMessage());
        }
        return Optional.empty();
    }

    // Gemini 프롬프트
    private String buildNutritionPrompt(String ingredients) {
        return "You are a nutrition information assistant. Given the ingredient list and amounts below, "
                + "return a JSON object and ONLY the JSON object (no explanation, no extra text) with the following keys: "
                + "\"calories\" (kcal), \"carbohydrate\" (grams), \"protein\" (grams), \"fat\" (grams). "
                + "Round numeric values to two decimal places. If a value is unknown, return 0.0.\n\n"
                + "Respond strictly as a single JSON object. Example:\n"
                + "{\"calories\": 250.50, \"carbohydrate\": 30.0, \"protein\": 10.0, \"fat\": 5.0}\n\n"
                + "Ingredients: " + ingredients;
    }

    // NutritionVO에 JSON 데이터 채우기
    private void fillNutritionFromJson(NutritionVO nutritionVO, JsonObject nutritionJson) {
        try {
            if (nutritionJson.has("calories")) {
                nutritionVO.setCalories(nutritionJson.get("calories").getAsDouble());
            }
            if (nutritionJson.has("carbohydrate")) {
                nutritionVO.setCarbohydrate(nutritionJson.get("carbohydrate").getAsDouble());
            }
            if (nutritionJson.has("protein")) {
                nutritionVO.setProtein(nutritionJson.get("protein").getAsDouble());
            }
            if (nutritionJson.has("fat")) {
                nutritionVO.setFat(nutritionJson.get("fat").getAsDouble());
            }
        } catch (Exception e) {
            log.error("Error parsing nutrition JSON fields", e);
        }
    }
}