package com.sell_buy.sell_buy.common.exception.errorCode;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    NOT_FOUND(404, "COMMON_ERR_404", "PAGE NOT FOUND"),
    PRODUCT_NOT_FOUND(404, "PRODUCT_ERR_404", "PRODUCT NOT FOUND");
    private final int status;
    private final String errorCode;
    private final String message;
}
