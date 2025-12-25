package com.sell_buy.sell_buy.common.exception.validation;

public class StringValidationException extends ValidationException {
    public StringValidationException(String message) {
        super(message);
    }

    public StringValidationException(String message, String errStr) {
        super(String.format("%s - Error String: %s", message, errStr));
    }

    public StringValidationException(String context, String message, String errStr) {
        super(context, String.format("%s - Error String: %s", message, errStr));
    }
}
