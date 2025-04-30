package com.example.banaomz.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_REQUEST(1000, "Invalid request", HttpStatus.BAD_REQUEST),

    OUT_OF_STOCK(1, "Số lượng trong kho không đủ", HttpStatus.BAD_REQUEST),
    PRODUCT_NOT_FOUND(2, "Sản phẩm không tồn tại", HttpStatus.NOT_FOUND),

    UNAUTHORIZED(3, "Không có quyền truy cập", HttpStatus.UNAUTHORIZED);
    ErrorCode(int code, String message, HttpStatusCode statusCode) {
        this.code = code;
        this.message = message;
        this.statusCode = statusCode;
    }

    private final int code;
    private final String message;
    private final HttpStatusCode statusCode;
}
