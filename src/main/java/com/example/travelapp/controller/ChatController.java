package com.example.travelapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.travelapp.model.User;
import com.example.travelapp.repo.UserRepository;
import com.example.travelapp.service.ChatService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

    @Autowired private ChatService chatService;
    @Autowired private UserRepository userRepository;

    @GetMapping("/chat")
    public String chatPage(Model model, HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "chat";
    }

    @PostMapping("/chat")
    public String getReply(@RequestParam String message, Model model, HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        model.addAttribute("reply", chatService.getRecommendations(user.getId(), message));
        return "chat";
    }

    private User getSessionUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            session.invalidate();
        }
        return user;
    }
}
