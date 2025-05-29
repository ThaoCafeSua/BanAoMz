package com.example.banaomz.service.common.impl;


import com.example.banaomz.dto.admin.mail.MailDTO;
import com.example.banaomz.dto.admin.mail.MailInputDTO;
import com.example.banaomz.service.common.IMailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class MailServiceImpl implements IMailService {
    @Autowired
    private JavaMailSender mailSender;


    @Override
    public void sendHtmlMail(MailDTO dataMail) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();

        MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

        helper.setTo(dataMail.getTo());
        helper.setSubject(dataMail.getSubject());
        helper.setText("<body>\n" +
                "    <p > Xin chào, "+dataMail.getProps().get("name")+"</p>\n" +
                "    <p>Chúng tôi gửi thông tin truy cập hệ thống của bạn:</p>\n" +
                "    <p> Tên truy cập: "+dataMail.getProps().get("email")+"</p>\n" +
                "    <p >Mật khẩu truy cập tạm thời: "+dataMail.getProps().get("password")+"</p>\n" +
                "    <p>Lưu ý: Đây là mật khẩu mặc định được tạo bởi hệ thống, hãy nhanh chóng thay đổi.</p>\n" +
                "    <p>Nếu có vấn đề về mật khẩu, hãy liên hệ hỗ trợ.</p>\n" +
                "    <p>Bạn vui lòng đổi lại để đảm bảo an toàn thông tin.</p>\n" +
                "    <p>Đây là email tự động, vui lòng không trả lời.</p>\n" +
                "</body>", true);

        mailSender.send(message);
    }

    @Override
    public Boolean create(MailInputDTO sdi) {
        try {
            MailDTO dataMail = new MailDTO();

            dataMail.setTo(sdi.getEmail());
            dataMail.setSubject("XÁC NHẬN TẠO MỚI THÔNG TIN NGƯỜI DÙNG");

            Map<String, Object> props = new HashMap<>();
            props.put("name", sdi.getName());
            props.put("email", sdi.getEmail());
            props.put("password", sdi.getPassword());
            dataMail.setProps(props);

            sendHtmlMail(dataMail);

            return true;
        } catch (MessagingException exp) {
            exp.printStackTrace();
        }
        return false;
    }
}
