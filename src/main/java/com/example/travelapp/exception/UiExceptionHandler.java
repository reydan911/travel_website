package com.example.travelapp.exception;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import com.example.travelapp.controller.AdminController;
import com.example.travelapp.controller.AuthController;
import com.example.travelapp.controller.BookingController;
import com.example.travelapp.controller.ChatController;
import com.example.travelapp.controller.DestinationController;
import com.example.travelapp.controller.HomeController;
import com.example.travelapp.controller.RecommendationController;

@ControllerAdvice(assignableTypes = {
        HomeController.class,
        DestinationController.class,
        BookingController.class,
        AdminController.class,
        AuthController.class,
        ChatController.class,
        RecommendationController.class
})
public class UiExceptionHandler {

    @ExceptionHandler({IllegalArgumentException.class, NotFoundException.class, EntityNotFoundException.class})
    public String handleKnown(RuntimeException ex, Model model, HttpServletRequest request) {
        model.addAttribute("message", ex.getMessage() == null ? "Something went wrong." : ex.getMessage());
        model.addAttribute("path", request.getRequestURI());
        return "error";
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public String handleTypeMismatch(MethodArgumentTypeMismatchException ex, Model model, HttpServletRequest request) {
        model.addAttribute("message", "Invalid value for " + ex.getName() + ".");
        model.addAttribute("path", request.getRequestURI());
        return "error";
    }
}
