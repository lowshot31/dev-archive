package com.sell_buy.sell_buy.common.exception.validation;

public class StringEmptyValidationException extends StringValidationException {
    public StringEmptyValidationException() {
        super("This string is null or empty");
    }

    public StringEmptyValidationException(String errStr) {
        super("This string is null or empty", errStr);
    }

    public StringEmptyValidationException(String context, String errStr) {
        super(context, "This string is null or empty", errStr);
    }
}
