package com.sell_buy.sell_buy.common.validation;


public class PasswordValidation extends StringValidation {

    public PasswordValidation(String value) {
        super(value, "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&.])[A-Za-z\\d@$!%*?&.]+$", 10, 30, false);
    }
}
