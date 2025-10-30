package org.mnu.controller;

import org.mnu.domain.CommentVO;
import org.mnu.service.CommentService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/comment/*")
@AllArgsConstructor
public class CommentController {

    private CommentService service;

    @PostMapping("/register")
    public String register(CommentVO vo, RedirectAttributes rttr) {
        service.register(vo);
        return "redirect:/recipe/get?bno=" + vo.getBno();
    }
}
