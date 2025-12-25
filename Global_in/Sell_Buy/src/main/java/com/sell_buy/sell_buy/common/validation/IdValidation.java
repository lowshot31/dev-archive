package com.sell_buy.sell_buy.common.validation;

public class IdValidation extends StringValidation {
    public IdValidation(String value) {
        super(value, "^[a-z0-9_]+$", 6, 20, false);
    }
}
