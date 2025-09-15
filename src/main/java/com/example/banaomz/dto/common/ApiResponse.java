package com.example.banaomz.dto.common;

import lombok.*;

@Data @AllArgsConstructor @NoArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;

    public static <T> ApiResponse<T> ok(T data){
        return new ApiResponse<>(true, null, data);
    }
    public static <T> ApiResponse<T> fail(String msg){
        return new ApiResponse<>(false, msg, null);
    }
}
