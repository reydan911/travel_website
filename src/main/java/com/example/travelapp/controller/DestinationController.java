package com.example.travelapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.travelapp.model.Destination;
import com.example.travelapp.model.User;
import com.example.travelapp.repo.DestinationRepository;
import com.example.travelapp.repo.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;

@Controller
public class DestinationController {

    @Autowired
    private DestinationRepository destinationRepository;
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/destination/{id}")
    public String destination(@PathVariable String id, Model model, HttpSession session) {
        Long userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login?next=/destination/" + id;
        }
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            session.invalidate();
            return "redirect:/login?next=/destination/" + id;
        }

        Destination destination = destinationRepository.findBySlug(id);
        if (destination == null) {
            return "redirect:/"; // fallback to home if id is wrong
        }

        model.addAttribute("user", user);
        model.addAttribute("destination", destination);
        model.addAttribute("destinationCity", extractCity(destination.getName()));
        return "destination"; // => destination.html
    }

    private Long getUserIdFromSession(HttpSession session) {
        Object raw = session.getAttribute("userId");
        if (raw instanceof Long) {
            return (Long) raw;
        }
        if (raw instanceof Integer) {
            return ((Integer) raw).longValue();
        }
        if (raw instanceof String) {
            try {
                return Long.parseLong(((String) raw).trim());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    private String extractCity(String name) {
        if (name == null) {
            return "";
        }
        String trimmed = name.trim();
        int commaIndex = trimmed.indexOf(',');
        if (commaIndex > 0) {
            return trimmed.substring(0, commaIndex).trim();
        }
        return trimmed;
    }
}
