package com.example.banaomz.dto.admin.mail;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MailInputDTO {
    private String name;
    private String email;
    private String password;
}
