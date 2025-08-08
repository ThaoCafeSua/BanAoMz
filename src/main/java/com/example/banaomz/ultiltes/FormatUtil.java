package com.example.banaomz.ultiltes;

import java.text.NumberFormat;
import java.util.Locale;

public class FormatUtil {
    public static String formatCurrency(double amount) {
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);
        return currencyFormatter.format(amount);
    }
}