package com.example.webapp.controller;

import com.example.webapp.client.PaymentServiceClient;
import com.example.webapp.client.dto.CardDto;
import com.example.webapp.client.dto.CardRequestDto;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import static com.example.webapp.controller.LoginController.*;

@Controller
@RequestMapping("/cards")
@RequiredArgsConstructor
public class CardsController {

    private final PaymentServiceClient paymentServiceClient;

    @GetMapping
    public String cards(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute(SESSION_USER_ID);
        if (userId == null) return "redirect:/login";

        List<CardDto> cards = paymentServiceClient.getCardsByUser(userId);
        model.addAttribute("cards", cards);
        model.addAttribute("userName", session.getAttribute(SESSION_USER_NAME));
        return "cards";
    }

    @PostMapping
    public String addCard(@RequestParam String cardHolder,
                          @RequestParam String cardNumber,
                          @RequestParam String cvv,
                          @RequestParam Integer expiryMonth,
                          @RequestParam Integer expiryYear,
                          HttpSession session,
                          RedirectAttributes ra) {
        Long userId = (Long) session.getAttribute(SESSION_USER_ID);
        if (userId == null) return "redirect:/login";

        String digits = cardNumber.replaceAll("\\s+", "");
        if (!digits.matches("\\d{16}")) {
            ra.addFlashAttribute("error", "Card number must have exactly 16 digits.");
            return "redirect:/cards";
        }

        if (!cvv.matches("\\d{3,4}")) {
            ra.addFlashAttribute("error", "CVV must have 3 or 4 digits.");
            return "redirect:/cards";
        }

        if (expiryMonth < 1 || expiryMonth > 12) {
            ra.addFlashAttribute("error", "Invalid expiry month.");
            return "redirect:/cards";
        }
        if (expiryYear < 2024) {
            ra.addFlashAttribute("error", "Card has expired.");
            return "redirect:/cards";
        }

        try {
            String lastFour = digits.substring(12);
            paymentServiceClient.addCard(new CardRequestDto(userId, cardHolder.trim(), lastFour, expiryMonth, expiryYear));
            ra.addFlashAttribute("success", "Card **** " + lastFour + " added successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error adding card: " + e.getMessage());
        }
        return "redirect:/cards";
    }

    @PostMapping("/{id}/delete")
    public String deleteCard(@PathVariable Long id,
                             HttpSession session,
                             RedirectAttributes ra) {
        Long userId = (Long) session.getAttribute(SESSION_USER_ID);
        if (userId == null) return "redirect:/login";

        try {
            paymentServiceClient.deleteCard(id);
            ra.addFlashAttribute("success", "Card deleted.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error deleting card: " + e.getMessage());
        }
        return "redirect:/cards";
    }
}
