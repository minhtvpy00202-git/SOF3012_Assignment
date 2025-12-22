package com.poly.oe.service.chatbot;

public class IntentDetector {

    public enum Intent {
        WEB,        // hỏi về website / chức năng
        SMALL_TALK, // trò chuyện ngoài lề
        UNKNOWN     // ngoài phạm vi
    }

    public static Intent detect(String message) {
        if (message == null || message.isBlank()) {
            return Intent.SMALL_TALK;
        }

        String m = message.toLowerCase();

        // ===== INTENT: WEBSITE =====
        if (containsAny(m,
                "đăng nhập", "đăng ký", "login", "signup",
                "like", "share", "bình luận", "comment",
                "video", "xem video", "tìm", "tìm kiếm",
                "mật khẩu", "đổi mật khẩu",
                "tài khoản", "hồ sơ",
                "admin", "quản lý",
                "báo cáo", "thống kê",
                "ngôn ngữ", "tiếng anh", "tiếng việt",
                "dark", "light", "sáng", "tối")) {

            return Intent.WEB;
        }

        // ===== INTENT: SMALL TALK =====
        if (containsAny(m,
                "chào", "hi", "hello",
                "khỏe", "vui", "buồn",
                "bạn là ai", "tên gì",
                "nói chuyện", "trò chuyện",
                "hôm nay", "rảnh không", "cuộc sống", "cảm xúc", "tình yêu", "học", "giận", "hờn", "đám cưới", "chơi")) {

            return Intent.SMALL_TALK;
        }

        // ===== UNKNOWN =====
        return Intent.UNKNOWN;
    }

    private static boolean containsAny(String text, String... keys) {
        for (String k : keys) {
            if (text.contains(k)) return true;
        }
        return false;
    }
}
