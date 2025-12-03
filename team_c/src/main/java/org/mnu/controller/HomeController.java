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
        log.info("HomeController /home 진입");
        return "home";
    }
}