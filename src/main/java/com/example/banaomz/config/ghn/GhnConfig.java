package com.example.banaomz.config.ghn;

import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.util.StringUtils;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

import java.time.Duration;

@Configuration
@EnableConfigurationProperties(GhnProperties.class)
@RequiredArgsConstructor
public class GhnConfig {

    private final GhnProperties props;

    @Bean("ghnWebClient")
    public WebClient ghnWebClient() {
        long timeoutMs = Math.max(1000, props.getTimeoutMs());

        HttpClient httpClient = HttpClient.create()
                .compress(true)
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, (int) timeoutMs)
                .responseTimeout(Duration.ofMillis(timeoutMs));

        return WebClient.builder()
                .baseUrl(props.getBaseUrl())
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .defaultHeaders(h -> {
                    h.setContentType(MediaType.APPLICATION_JSON);
                    h.setAccept(java.util.List.of(MediaType.APPLICATION_JSON));
                    if (StringUtils.hasText(props.getToken())) {
                        h.add("Token", props.getToken());
                    }
                    if (props.getShopId() != null) {
                        h.add("ShopId", String.valueOf(props.getShopId()));
                    }
                })
                .exchangeStrategies(ExchangeStrategies.builder()
                        .codecs(c -> c.defaultCodecs().maxInMemorySize(4 * 1024 * 1024))
                        .build())
                .build();
    }

}
