package com.example.banaomz.ultiltes;

import java.text.Normalizer;

public class SlugUtils {
    public static String toSlug(String input) {
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        String noDiacritics = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return noDiacritics.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")   // bỏ ký tự đặc biệt
                .replaceAll("\\s+", "-")           // thay space = -
                .replaceAll("-+", "-");            // gộp nhiều - thành 1
    }
}
