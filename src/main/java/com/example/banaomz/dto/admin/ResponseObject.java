package com.example.banaomz.dto.admin;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class ResponseObject {
    private String status;
    private String message;
    private int errCode;
    private Object data;
}
