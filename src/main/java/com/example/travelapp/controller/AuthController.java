package com.example.travelapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.travelapp.model.User;
import com.example.travelapp.repo.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String next, Model model) {
        if (next != null && !next.isBlank()) {
            model.addAttribute("next", next);
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam(required = false) String identifier,
            @RequestParam(required = false) String password,
            @RequestParam(required = false) String next,
            HttpSession session,
            Model model) {

        String lookup = identifier == null ? "" : identifier.trim();
        if (lookup.isEmpty()) {
            model.addAttribute("error", "Please enter your email or username");
            return "login";
        }
        String pwd = password == null ? "" : password;
        if (pwd.isEmpty()) {
            model.addAttribute("error", "Please enter your password");
            return "login";
        }
        User user = userRepository.findByEmail(lookup);
        if (user == null) {
            user = userRepository.findByUsername(lookup);
        }

        if (user == null) {
            model.addAttribute("error", "Invalid email or password");
            return "login";
        }

        if (!passwordEncoder.matches(pwd, user.getPasswordHash())) {
            model.addAttribute("error", "Invalid email or password");
            return "login";
        }

        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());

        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/admin";
        }
        String safeNext = safeRedirect(next);
        if (safeNext != null) {
            return "redirect:" + safeNext;
        }
        return "redirect:/";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        try {
            if (userRepository.findByEmail(email) != null) {
                model.addAttribute("error", "Email already exists");
                return "register";
            }

            if (userRepository.findByUsername(username) != null) {
                model.addAttribute("error", "Username already exists");
                return "register";
            }

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(passwordEncoder.encode(password));
            user.setVerified(true);

            user = userRepository.save(user);

            // Automatically log in the user after registration
            if (user.getId() != null) {
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                return "redirect:/";
            } else {
                model.addAttribute("error", "Registration failed. Please try again.");
                return "register";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    private String safeRedirect(String next) {
        if (next == null) {
            return null;
        }
        String trimmed = next.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        if (!trimmed.startsWith("/")) {
            return null;
        }
        if (trimmed.startsWith("//")) {
            return null;
        }
        return trimmed;
    }
}
