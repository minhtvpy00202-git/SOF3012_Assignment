package com.poly.oe.controller.customer;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.poly.oe.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.poly.oe.service.chatbot.IntentDetector;


@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Encoding + response type
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json");

        // 2. Lấy message từ client
        String message = req.getParameter("message");

        String reply;
        boolean fromOpenAI = false;

        // 3. Detect intent (CỐT LÕI)
        IntentDetector.Intent intent = IntentDetector.detect(message);

        // 4. Lấy API key
        String apiKey = System.getenv("OPENAI_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            apiKey = getServletContext().getInitParameter("OPENAI_API_KEY");
        }

        try {
            // ===== INTENT: WEBSITE =====
            if (intent == IntentDetector.Intent.WEB) {

                if (apiKey != null && !apiKey.isBlank()) {
                    reply = callOpenAI(req, message, apiKey);

                    if (reply != null && !reply.isBlank()) {
                        fromOpenAI = true;
                    } else {
                        reply = generateReply(req, message); // fallback an toàn
                    }

                } else {
                    reply = generateReply(req, message);
                }

            }
            // ===== INTENT: SMALL TALK =====
            else if (intent == IntentDetector.Intent.SMALL_TALK) {

                if (apiKey != null && !apiKey.isBlank()) {
                    reply = callOpenAI(req, message, apiKey);
                    fromOpenAI = true;

                    // 👉 Thêm emoji nhẹ cho small talk
                    reply = addSmallTalkEmoji(reply);

                } else {
                    reply = "Mình đang ở đây nè 😊";
                }
            }

            // ===== INTENT: UNKNOWN =====
            else {
                reply = "Tính năng này hiện chưa được hỗ trợ trên website OE.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            reply = generateReply(req, message);
        }

        // 5. Trả JSON về frontend
        String source = fromOpenAI ? "openai" : "fallback";
        String json = "{"
                + "\"reply\":\"" + escapeJson(reply) + "\","
                + "\"source\":\"" + source + "\""
                + "}";

        resp.getWriter().write(json);

        // Log debug
        System.out.println("INTENT = " + intent);
        System.out.println("FROM OPENAI = " + fromOpenAI);
    }



    private String generateReply(HttpServletRequest req, String message) {
        String name = null;
        Object u = req.getSession(false) != null ? req.getSession(false).getAttribute("currentUser") : null;
        if (u instanceof User) {
            User user = (User) u;
            name = user.getFullname() != null && !user.getFullname().isBlank() ? user.getFullname() : user.getId();
        }

        String m = message == null ? "" : message.trim();
        String lm = m.toLowerCase(Locale.ROOT);

        String greet = name != null ? ("Chào " + name + "! ") : "Chào bạn! ";

        if (lm.isBlank()) {
            return greet + "Mình là trợ lý OE. Bạn có thể hỏi về: tìm video, yêu thích, chia sẻ, đăng nhập/đăng ký, quên mật khẩu, hay cách đổi giao diện.";
        }

        if (containsAny(lm, "xin chao", "chao", "hello", "hi")) {
            return greet + "Mình có thể hỗ trợ tìm video, quản lý mục yêu thích và tài khoản.";
        }

        if (containsAny(lm, "tim", "search", "video")) {
            return greet + "Để tìm video, nhập từ khóa vào ô tìm kiếm trên thanh tìm kiếm và nhấn nút Tìm. Bạn cũng có thể truy cập \"Trang chủ\" để duyệt các video phổ biến.";
        }

        if (containsAny(lm, "yeu thich", "like", "favorite")) {
            return greet + "Ở trang chi tiết video, bấm nút Thích để thêm vào mục yêu thích. Vào \"Mục yêu thích của tôi\" để xem tất cả.";
        }

        if (containsAny(lm, "dang nhap", "login")) {
            return greet + "Vào \"Tài khoản -> Đăng nhập\" hoặc truy cập \"" + req.getContextPath() + "/login\".";
        }

        if (containsAny(lm, "dang ky", "registration", "signup")) {
            return greet + "Vào \"Tài khoản -> Đăng ký\" hoặc truy cập \"" + req.getContextPath() + "/account/registration\".";
        }

        if (containsAny(lm, "quen mat khau", "forgot", "reset password")) {
            return greet + "Vào \"Tài khoản -> Quên mật khẩu\" hoặc truy cập \"" + req.getContextPath() + "/account/forgot-password\".";
        }

        if (containsAny(lm, "doi mat khau", "change password")) {
            return greet + "Vào \"Tài khoản -> Đổi mật khẩu\" hoặc truy cập \"" + req.getContextPath() + "/account/change-password\".";
        }

        if (containsAny(lm, "admin", "quan tri")) {
            return greet + "Nếu tài khoản có quyền admin, dùng menu \"Bảng điều khiển Admin\" để quản lý video, người dùng và báo cáo.";
        }

        if (containsAny(lm, "giao dien", "theme", "dark", "light")) {
            return greet + "Dùng nút chuyển chế độ ở thanh trên cùng để đổi giữa giao diện sáng/tối. Cài đặt được lưu trong trình duyệt.";
        }

        return greet + "Mình chưa hiểu câu hỏi của bạn. Hãy thử hỏi về: tìm video, yêu thích, đăng nhập/đăng ký, quên mật khẩu, hoặc đổi giao diện.";
    }

    private String callOpenAI(HttpServletRequest req, String message, String apiKey) throws Exception {

        String userMsg = message == null ? "" : message.trim();
        String siteLang = (String) req.getSession().getAttribute("siteLang");
        if(siteLang == null) siteLang = "vi";

        String body = "{"
                + "\"model\":\"gpt-4.1-mini\","
                + "\"input\":["
                + " {\"role\":\"system\",\"content\":\""
                + "Bạn là trợ lý chatbot CHÍNH THỨC của website OE Online Entertainment – một website chia sẻ video giải trí. "

                + "NGÔN NGỮ GIAO DIỆN HIỆN TẠI: " + siteLang + ". "
                + "Nếu siteLang = vi, hãy trả lời hoàn toàn bằng tiếng Việt. "
                + "Nếu siteLang = en, hãy trả lời hoàn toàn bằng tiếng Anh. "

                + "================ THÔNG TIN WEBSITE ================= "
                + "Website OE hiện có khoảng 9 video và sẽ tiếp tục bổ sung thêm nhiều video mới trong tương lai. "
                + "Website hỗ trợ chuyển đổi ngôn ngữ Tiếng Việt / Tiếng Anh, "
                + "chế độ hiển thị Sáng / Tối, "
                + "và có tính năng gợi ý dịch bình luận sang ngôn ngữ giao diện hiện tại. "

                + "================ PHÂN QUYỀN NGƯỜI DÙNG ================= "

                + "1) Người dùng CHƯA đăng nhập: "
                + "Chỉ có thể xem video, xem mô tả và xem bình luận. "
                + "Không thể like, share, bình luận hoặc trả lời bình luận. "

                + "2) Người dùng ĐÃ đăng nhập: "
                + "Có thể xem video, like/unlike, share video, "
                + "viết bình luận, trả lời bình luận, "
                + "xem danh sách video đã like, video đã xem, "
                + "chỉnh sửa hồ sơ cá nhân, đổi mật khẩu, "
                + "xem hộp thư (Inbox) và thông báo. "

                + "3) Quản trị viên (Admin): "
                + "Có toàn bộ quyền của người dùng đã đăng nhập, "
                + "và có thêm các chức năng quản trị sau: "
                + "quản lý video, quản lý người dùng, "
                + "gửi thông báo đến người dùng, "
                + "xem thống kê và báo cáo. "

                + "================ HƯỚNG DẪN SỬ DỤNG CỤ THỂ ================= "

                + "• Đăng nhập: "
                + "Nhấn nút Log In / Đăng nhập ở góc trên bên phải, "
                + "nhập tên đăng nhập và mật khẩu, sau đó bấm Đăng nhập. "
                + "Nếu quên mật khẩu, bấm vào liên kết Quên mật khẩu. "

                + "• Đăng ký tài khoản: "
                + "Vào menu Tài khoản → Đăng ký, "
                + "điền đầy đủ thông tin và gửi đăng ký, "
                + "sau đó chờ Admin duyệt tài khoản. "

                + "• Đổi ngôn ngữ: "
                + "Bấm vào nút chọn ngôn ngữ (EN / VI) ở góc trên bên phải. "

                + "• Chỉnh sửa hồ sơ: "
                + "Vào Tài khoản → Chỉnh sửa hồ sơ. "

                + "• Đổi mật khẩu: "
                + "Vào Tài khoản → Đổi mật khẩu. "

                + "• Xem hộp thư (Inbox): "
                + "Vào Tài khoản → Hộp thư. "

                + "• Video đã like / video đã xem: "
                + "Nằm trong Menu người dùng sau khi đăng nhập. "

                + "• Gửi thông báo (CHỈ DÀNH CHO ADMIN): "
                + "Đăng nhập bằng tài khoản Admin, "
                + "sau đó bấm vào menu 'Gửi thông báo' trên thanh Menu của giao diện Admin. "

                + "• Các chức năng quản trị khác (Admin): "
                + "Đăng nhập bằng tài khoản Admin, "
                + "sau đó sử dụng các mục tương ứng trên thanh Menu "
                + "(Quản lý video, Quản lý người dùng, Báo cáo). "

                + "================ QUY TẮC TRẢ LỜI BẮT BUỘC ================= "

                + "- Khi người dùng hỏi về TÍNH NĂNG CỦA WEBSITE: "
                + "hãy hướng dẫn rõ ràng từng bước dựa trên thông tin ở trên. "

                + "- TUYỆT ĐỐI KHÔNG trả lời câu: "
                + "'Tính năng này hiện chưa được hỗ trợ trên website OE.' "

                + "- Nếu câu hỏi liên quan đến website nhưng bạn KHÔNG CHẮC hoặc KHÔNG CÓ THÔNG TIN: "
                + "hãy trả lời đúng câu sau: "
                + "'Mình chưa được hiểu rõ về tính năng này, bạn hãy liên hệ Admin để được hỗ trợ tốt hơn nhé!' "

                + "- Nếu câu hỏi KHÔNG liên quan đến website "
                + "(chào hỏi, trò chuyện, câu vô nghĩa, spam, small talk): "
                + "hãy trả lời tự nhiên, vui vẻ, thân thiện, "
                + "KHÔNG nhắc đến website hoặc tính năng. "

                + "Phong cách trả lời: ngắn gọn, rõ ràng, thân thiện.\"},"

                + " {\"role\":\"user\",\"content\":\"" + escapeJson(userMsg) + "\"}"
                + "]"
                + "}";



        HttpClient client = HttpClient.newHttpClient();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/responses"))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response =
                client.send(request, HttpResponse.BodyHandlers.ofString());

        System.out.println("=== OPENAI STATUS === " + response.statusCode());
        System.out.println("=== OPENAI BODY ===");
        System.out.println(response.body());

        if (response.statusCode() != 200) {
            return null;
        }

        return extractFromResponsesAPI(response.body());
    }



    private String extractFromResponsesAPI(String json) {
        try {
            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            JsonArray output = root.getAsJsonArray("output");
            if (output == null || output.size() == 0) return null;

            JsonObject message = output.get(0).getAsJsonObject();
            JsonArray content = message.getAsJsonArray("content");
            if (content == null || content.size() == 0) return null;

            JsonObject textObj = content.get(0).getAsJsonObject();
            return textObj.get("text").getAsString();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }










    private boolean containsAny(String text, String... keys) {
        for (String k : keys) {
            if (text.contains(k)) return true;
        }
        return false;
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20) {
                        String hex = Integer.toHexString(c);
                        sb.append("\\u");
                        for (int j = hex.length(); j < 4; j++) sb.append('0');
                        sb.append(hex);
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
    private String addSmallTalkEmoji(String text) {
        if (text == null || text.isBlank()) return text;

        // Nếu đã có emoji thì thôi
        if (text.matches(".*[😊😂😄😉🙂😁😅😍].*")) {
            return text;
        }

        // Emoji nhẹ, trung tính
        String[] emojis = {"😊", "🙂", "😉", "😄"};

        // Random nhẹ
        int idx = (int) (Math.random() * emojis.length);

        return text + " " + emojis[idx];
    }

}
