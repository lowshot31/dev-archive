package com.sell_buy.sell_buy.common.exception.validation;

public class ValidationException extends RuntimeException {
    public ValidationException(String message) {
        super(message);
    }

    public ValidationException(String context, String message) {
        super(String.format("%s (Context: %s)", context, message));
    }
}
