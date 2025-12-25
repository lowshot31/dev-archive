package com.sell_buy.sell_buy.common.exception.validation;

public class StringLengthValidateException extends StringValidationException {
    public StringLengthValidateException(int min, int max) {
        super(String.format("String length should be between %d and %d", min, max));
    }

    public StringLengthValidateException(int min, int max, String errStr) {
        super(String.format("String length should be between %d and %d", min, max), errStr);
    }

    public StringLengthValidateException(String context, int min, int max) {
        super(context, String.format("String length should be between %d and %d", min, max));
    }

    public StringLengthValidateException(String context, int min, int max, String errStr) {
        super(context, String.format("String length should be between %d and %d", min, max), errStr);
    }
}
