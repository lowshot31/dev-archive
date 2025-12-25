package com.sell_buy.sell_buy.config;

import com.sell_buy.sell_buy.common.exception.auth.AuthenticateNotMatchException;
import com.sell_buy.sell_buy.common.exception.product.ProductAlreadyExistsException;
import com.sell_buy.sell_buy.common.exception.product.ProductNotFoundException;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(AuthenticationException.class)
    public ModelAndView handleAuthenticationException(AuthenticationException e, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("exception");
        response.setStatus(HttpStatus.UNAUTHORIZED.value());

        log.error("AuthenticationException occurred: ", e);
        modelAndView.addObject("errorCode", HttpStatus.UNAUTHORIZED.value());
        modelAndView.addObject("errorMessage", "User not authenticated.");
        return modelAndView;
    }

    @ExceptionHandler(AuthenticateNotMatchException.class)
    public ModelAndView handleAuthenticateNotMatchException(AuthenticateNotMatchException e, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("exception");
        response.setStatus(HttpStatus.UNAUTHORIZED.value());

        log.error("AuthenticateNotMatchException occurred: ", e);
        modelAndView.addObject("errorCode", HttpStatus.UNAUTHORIZED.value());
        modelAndView.addObject("errorMessage", e.getMessage());
        return modelAndView;
    }

    @ExceptionHandler(ProductAlreadyExistsException.class)
    public ModelAndView handleProductAlreadyExistsException(ProductAlreadyExistsException e, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("exception");
        response.setStatus(HttpStatus.CONFLICT.value());

        log.error("ProductAlreadyExistsException occurred: ", e);
        modelAndView.addObject("errorCode", HttpStatus.CONFLICT.value());
        modelAndView.addObject("errorMessage", e.getMessage());
        return modelAndView;
    }

    @ExceptionHandler(ProductNotFoundException.class)
    public ModelAndView handleProductNotFoundException(ProductNotFoundException e, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("exception");
        response.setStatus(HttpStatus.NOT_FOUND.value());

        log.error("ProductNotFoundException occurred: ", e);
        modelAndView.addObject("errorCode", HttpStatus.NOT_FOUND.value());
        modelAndView.addObject("errorMessage", e.getMessage());
        return modelAndView;
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleException(Exception e, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("exception");
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());

        log.error("Exception occurred: ", e);
        modelAndView.addObject("errorCode", HttpStatus.INTERNAL_SERVER_ERROR.value());
        modelAndView.addObject("errorMessage", "Internal server error occurred. Please try again later.");
        return modelAndView;
    }

}
