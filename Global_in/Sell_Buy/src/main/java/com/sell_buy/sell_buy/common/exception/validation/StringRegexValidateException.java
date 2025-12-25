package com.sell_buy.sell_buy.common.exception.validation;

public class StringRegexValidateException extends StringValidationException {
    public StringRegexValidateException(String regex, String errStr) {
        super(String.format("Not matching string with regex '%s'", regex), errStr);
    }

    public StringRegexValidateException(String context, String regex, String errStr) {
        super(context, String.format("Not matching string with regex '%s'", regex), errStr);
    }
}
