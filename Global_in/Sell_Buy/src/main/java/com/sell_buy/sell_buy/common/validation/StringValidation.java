package com.sell_buy.sell_buy.common.validation;

import com.sell_buy.sell_buy.common.exception.validation.StringLengthValidateException;
import com.sell_buy.sell_buy.common.exception.validation.StringRegexValidateException;
import com.sell_buy.sell_buy.common.exception.validation.StringValidationException;

public class StringValidation implements Validation {

    private final String value;
    private final String regex;

    private final int min;
    private final int max;

    private final boolean exclusive;

    public StringValidation(String value, String regex, int min, int max, boolean exclusive) {
        this.value = value;
        this.regex = regex;
        this.min = min;
        this.max = max;
        this.exclusive = exclusive;
    }

    public StringValidation(String value) {
        this.value = value;
        this.regex = null;
        this.min = 0;
        this.max = 0;
        this.exclusive = false;
    }

    public StringValidation(String value, int min, int max, boolean exclusive) {
        this.value = value;
        this.regex = null;
        this.min = min;
        this.max = max;
        this.exclusive = exclusive;
    }

    public StringValidation(String value, String regex) {
        this.value = value;
        this.regex = regex;
        this.min = 0;
        this.max = 0;
        this.exclusive = false;
    }

    @Override
    public boolean validate() throws StringValidationException {
        return emptyValidation() && lengthValidation() && regexValidation();
    }

    private boolean regexValidation() throws StringValidationException {
        if (this.regex == null || this.regex.isEmpty()) {
            return true;
        }
        if (this.value.matches(this.regex)) {
            return true;
        }
        throw new StringRegexValidateException(this.regex, this.value);
    }

    private boolean lengthValidation() throws StringValidationException {
        if (this.min == 0 && this.max == 0) {
            return true;
        }
        if (this.exclusive) {
            if (min < this.value.length() && this.value.length() < this.max) {
                return true;
            }
        } else {
            if (min <= this.value.length() && this.value.length() <= this.max) {
                return true;
            }
        }
        throw new StringLengthValidateException(this.min, this.max, this.value);
    }

    private boolean emptyValidation() throws StringValidationException {
        if (this.value == null || this.value.isEmpty()) {
            throw new StringValidationException(this.value);
        }
        return true;
    }
}
