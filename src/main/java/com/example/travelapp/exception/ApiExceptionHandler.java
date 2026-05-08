package com.example.travelapp.exception;

import java.time.OffsetDateTime;
import java.util.Optional;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

@RestControllerAdvice(basePackages = "com.example.travelapp.controller.api")
public class ApiExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleInvalidArgs(
            MethodArgumentNotValidException ex,
            HttpServletRequest request) {
        return build(HttpStatus.BAD_REQUEST, firstFieldMessage(ex.getBindingResult()), request);
    }

    @ExceptionHandler(BindException.class)
    public ResponseEntity<ErrorResponse> handleBind(BindException ex, HttpServletRequest request) {
        return build(HttpStatus.BAD_REQUEST, firstFieldMessage(ex.getBindingResult()), request);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ErrorResponse> handleConstraint(
            ConstraintViolationException ex,
            HttpServletRequest request) {
        String message = ex.getConstraintViolations().stream()
                .findFirst()
                .map(violation -> violation.getPropertyPath() + " " + violation.getMessage())
                .orElse("Invalid request parameters.");
        return build(HttpStatus.BAD_REQUEST, message, request);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(
            MethodArgumentTypeMismatchException ex,
            HttpServletRequest request) {
        String message = "Invalid value for parameter '" + ex.getName() + "'.";
        return build(HttpStatus.BAD_REQUEST, message, request);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleNotReadable(
            HttpMessageNotReadableException ex,
            HttpServletRequest request) {
        return build(HttpStatus.BAD_REQUEST, "Invalid request body.", request);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingParam(
            MissingServletRequestParameterException ex,
            HttpServletRequest request) {
        String message = "Missing required parameter '" + ex.getParameterName() + "'.";
        return build(HttpStatus.BAD_REQUEST, message, request);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArg(
            IllegalArgumentException ex,
            HttpServletRequest request) {
        String message = Optional.ofNullable(ex.getMessage()).orElse("Invalid request.");
        return build(HttpStatus.BAD_REQUEST, message, request);
    }

    @ExceptionHandler({NotFoundException.class, EntityNotFoundException.class})
    public ResponseEntity<ErrorResponse> handleNotFound(
            Exception ex,
            HttpServletRequest request) {
        String message = Optional.ofNullable(ex.getMessage()).orElse("Resource not found.");
        return build(HttpStatus.NOT_FOUND, message, request);
    }

    private ResponseEntity<ErrorResponse> build(HttpStatus status, String message, HttpServletRequest request) {
        ErrorResponse body = new ErrorResponse(
                OffsetDateTime.now().toString(),
                status.value(),
                status.getReasonPhrase(),
                message,
                request.getRequestURI()
        );
        return new ResponseEntity<>(body, status);
    }

    private String firstFieldMessage(org.springframework.validation.BindingResult bindingResult) {
        FieldError fieldError = bindingResult.getFieldErrors().stream().findFirst().orElse(null);
        if (fieldError == null) {
            return "Invalid request parameters.";
        }
        String field = fieldError.getField();
        String message = fieldError.getDefaultMessage();
        if (message == null || message.isBlank()) {
            return "Invalid value for '" + field + "'.";
        }
        return field + " " + message;
    }
}
