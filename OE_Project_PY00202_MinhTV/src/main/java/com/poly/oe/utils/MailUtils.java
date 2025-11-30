package com.poly.oe.utils;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class MailUtils {

    private static String USERNAME_DEFAULT = "minh.tv.nh@gmail.com";
    private static String PASSWORD_DEFAULT = "lthb blwm pfbg rzjf";

    public static void configureDefaults(String username, String appPassword) {
        USERNAME_DEFAULT = username != null ? username.trim() : "";
        PASSWORD_DEFAULT = appPassword != null ? appPassword.trim() : "";
    }

    public static void sendHtmlMail(String toEmail, String subject, String htmlContent)
            throws MessagingException {

        String username = System.getProperty("mail.username");
        String password = System.getProperty("mail.password");

        if (username == null || username.isBlank()) {
            username = System.getenv("MAIL_USERNAME");
        }
        if (password == null || password.isBlank()) {
            password = System.getenv("MAIL_APP_PASSWORD");
        }

        if (username == null || username.isBlank()) {
            username = USERNAME_DEFAULT;
        }
        if (password == null || password.isBlank()) {
            password = PASSWORD_DEFAULT;
        }

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new MessagingException("Thiếu cấu hình email gửi. Hãy set MAIL_USERNAME và MAIL_APP_PASSWORD.");
        }

        // Trim password để tránh lỗi copy có khoảng trắng
        password = password.trim();

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.transport.protocol", "smtp");

        // Timeout để tránh treo nếu server email chậm
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        final String user = username;
        final String pass = password;

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        // BẬT debug khi cần xem log SMTP
        session.setDebug(true);

        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(username));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject, "UTF-8");
        msg.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(msg);
    }
}
