package com.example.banaomz.service.common;


import com.example.banaomz.dto.admin.mail.MailDTO;
import com.example.banaomz.dto.admin.mail.MailInputDTO;
import jakarta.mail.MessagingException;

public interface IMailService {

    void sendHtmlMail(MailDTO dataMail) throws MessagingException;

    Boolean create(MailInputDTO sdi);
}
