package org.mnu.controller;

import org.mnu.service.MemberService;
import org.mnu.service.ReportService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/admin/*")
@AllArgsConstructor
public class AdminController {

    private MemberService memberService;
    private ReportService reportService;

    @GetMapping("/main")
    public void adminMain() {
        log.info("====== 관리자 페이지로 이동 ======");
    }

    @GetMapping("/memberList")
    public void memberList(Model model) {
        log.info("====== 관리자용 회원 목록 페이지 ======");
        model.addAttribute("list", memberService.getList());
    }

    @GetMapping("/reportList")
    public void reportList(Model model) {
        log.info("====== 관리자용 신고 목록 페이지 ======");
        model.addAttribute("list", reportService.getList());
    }
}