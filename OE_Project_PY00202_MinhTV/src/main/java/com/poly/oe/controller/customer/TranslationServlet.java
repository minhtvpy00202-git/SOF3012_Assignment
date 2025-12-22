package com.poly.oe.controller.customer;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet({"/translation/suggest"})
public class TranslationServlet extends HttpServlet {
    // ===== CACHE TRANSLATION =====
    private static final Map<String, String> TRANSLATION_CACHE = new ConcurrentHashMap<>();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json");

        String content = req.getParameter("content");
        String targetLang = req.getParameter("targetLang");

        // ===== 1. Ngôn ngữ giao diện =====
        if (targetLang == null || targetLang.isBlank()) {
            Object s = req.getSession(false) != null
                    ? req.getSession(false).getAttribute("siteLang")
                    : null;
            targetLang = s instanceof String ? (String) s : "vi";
        }
        targetLang = targetLang.toLowerCase();

        if (content == null || content.isBlank()) {
            writeFalse(resp);
            return;
        }

        // ===== 2. Detect ngôn ngữ comment =====
        String detected = detectLang(content);

        // ❌ cùng ngôn ngữ UI → KHÔNG gợi ý
        if (detected.equalsIgnoreCase(targetLang)) {
            writeFalse(resp);
            return;
        }

        // ===== 3. Gọi MyMemory =====
        String cacheKey = detected + "|" + targetLang + "|" + content;

        String translation = TRANSLATION_CACHE.get(cacheKey);

        if (translation == null) {
            translation = translate(content, detected, targetLang);
            if (translation != null) {
                TRANSLATION_CACHE.put(cacheKey, translation);
            }
        }


        if (translation == null) {
            writeFalse(resp);
            return;
        }

        // ===== 4. Trả kết quả =====
        String json = """
        {
          "suggestTranslation": true,
          "translation": "%s",
          "detectedLang": "%s"
        }
        """.formatted(escapeJson(translation), detected);

        resp.getWriter().write(json);
    }

    private void writeFalse(HttpServletResponse resp) throws IOException {
        resp.getWriter().write("{\"suggestTranslation\":false}");
    }

    // ================= TRANSLATE (MyMemory) =================
    private String translate(String text, String source, String target) {
        try {
            String encodedText = URLEncoder.encode(text, StandardCharsets.UTF_8);
            String langpair = URLEncoder.encode(source + "|" + target, StandardCharsets.UTF_8);

            String url = "https://api.mymemory.translated.net/get"
                    + "?q=" + encodedText
                    + "&langpair=" + langpair;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("User-Agent", "MinhTV/1.0")
                    .GET()
                    .build();

            HttpResponse<String> response =
                    HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) return null;

            JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();
            JsonObject data = root.getAsJsonObject("responseData");
            return data.get("translatedText").getAsString();

        } catch (Exception e) {
            return null;
        }
    }

    // ================= LANGUAGE DETECT =================
    private String detectLang(String text) {
        if (text == null || text.isBlank()) return "en";

        String raw = text.toLowerCase();
        String t = normalize(raw);

        // ===== 1. Script đặc thù (100%) =====
        if (raw.matches(".*[\\u3040-\\u30FF].*")) return "ja";
        if (raw.matches(".*[\\u4E00-\\u9FFF].*")) return "zh";
        if (raw.matches(".*[\\uAC00-\\uD7AF].*")) return "ko";
        if (raw.matches(".*[\\u0600-\\u06FF].*")) return "ar";
        if (raw.matches(".*[\\u0400-\\u04FF].*")) return "ru";

        // ===== 2. Vietnamese =====
        // ===== 2. Vietnamese (CHỈ đặc trưng Việt) =====
        if (raw.matches(".*[đơưă].*")) {
            return "vi";
        }


        // ===== 3. Scoring Latin languages =====
        int pt = 0, fr = 0, es = 0, it = 0;

        pt += score(t, "gostei", "muito", "deste", "faca", "mais", "obrigado");
        pt += scorePhrase(t, "por favor");

        fr += score(t, "merci", "beaucoup", "cette", "pour", "faire", "plus",  "veuillez",  "video");

        es += score(t, "gracias", "mucho", "este", "hacer", "mas", "por favor");

        it += score(t, "grazie", "molto", "questo", "fare", "piu");

        int max = Math.max(Math.max(pt, fr), Math.max(es, it));

        // ===== 4. Ngưỡng tin cậy THẤP HƠN =====
        if (max >= 2) {
            if (max == pt) return "pt";
            if (max == fr) return "fr";
            if (max == es) return "es";
            if (max == it) return "it";
        }

        System.out.println("RAW = " + raw);
        System.out.println("NORM = " + t);
        System.out.println("PT=" + pt + " FR=" + fr + " ES=" + es + " IT=" + it);

        return "en";



    }

    private String normalize(String text) {
        return text
                .toLowerCase()
                .replaceAll("[^a-z\\s]", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private int score(String text, String... words) {
        int s = 0;
        for (String w : words) {
            if (text.contains(w)) s += 2;
        }
        return s;
    }

    private int scorePhrase(String text, String phrase) {
        return text.contains(phrase) ? 3 : 0;
    }



    // ================= UTILS =================
    private boolean isNearlySame(String a, String b) {
        if (a == null || b == null) return true;
        String x = a.trim().toLowerCase().replaceAll("[\\p{Punct}\\s]+", "");
        String y = b.trim().toLowerCase().replaceAll("[\\p{Punct}\\s]+", "");
        return x.equals(y);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
