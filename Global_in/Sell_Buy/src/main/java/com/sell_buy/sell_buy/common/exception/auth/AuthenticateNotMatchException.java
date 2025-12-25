package com.sell_buy.sell_buy.common.exception.auth;

import javax.naming.AuthenticationException;

public class AuthenticateNotMatchException extends AuthenticationException {
    public AuthenticateNotMatchException(String message) {
        super(message);
    }
}
