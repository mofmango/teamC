package org.mnu.controller;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/home")
public class HomeController {

    @GetMapping("") 
    public String home(Locale locale, Model model) {

        // ==============================
        // 여기부터는 네 기존 로직 그대로
        // ==============================
        log.info("HomeController /home 진입");

        // 예: model.addAttribute(...)
        // ==============================

        return "home"; // /WEB-INF/views/home.jsp 로 가는 기존 뷰명 유지
    }
}