package com.example.banaomz.dto.ghn;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class GhnResponse<T> {
    private Integer code;
    private String  message;

    @JsonProperty("message_display")
    private String  messageDisplay;

    @JsonProperty("code_message_key")
    private String  codeMessageKey;

    private T data;

    public boolean isOk() {
        return code != null && code == 200;
    }

    public String getEffectiveMessage() {
        return (messageDisplay != null && !messageDisplay.isBlank()) ? messageDisplay : message;
    }
}
