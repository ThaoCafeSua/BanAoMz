package com.example.banaomz.exception;

import com.example.banaomz.dto.admin.ResponseObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(value = RuntimeException.class)
    ResponseEntity<ResponseObject> handlingRuntimeException(RuntimeException exception) {
        ResponseObject responseObject = ResponseObject.builder()
                .errCode(ErrorCode.UNCATEGORIZED_EXCEPTION.getCode())
                .message(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage())
                .build();
        return ResponseEntity.badRequest().body(responseObject);
    }

    @ExceptionHandler(value = AppException.class)
    ResponseEntity<ResponseObject> handlingAppException(AppException exception){
        ErrorCode errorCode = exception.getErrorCode();
        ResponseObject responseObject = ResponseObject.builder()
                .errCode(errorCode.getCode())
                .message(errorCode.getMessage())
                .build();
        return ResponseEntity.badRequest().body(responseObject);
    }

}
