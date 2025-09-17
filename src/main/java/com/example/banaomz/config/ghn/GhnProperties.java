package com.example.banaomz.config.ghn;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "ghn")
public class GhnProperties {
    private String  baseUrl;
    private String  token;
    private Integer shopId;
    private Integer fromDistrictId;
    private String  fromWardCode;
    private long    timeoutMs = 7000;
}
