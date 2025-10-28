package org.mnu.controller;

import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.mnu.domain.ReportVO;
import org.mnu.service.ReportService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/report/*")
@AllArgsConstructor
public class ReportController {

    private ReportService service;

    // 신고 페이지로 이동
    @GetMapping("/register")
    public void register(@RequestParam("bno") Long bno, @RequestParam("reported_id") String reported_id, Model model) {
        log.info(bno + "번 게시글 신고 페이지로 이동");
        model.addAttribute("bno", bno);
        model.addAttribute("reported_id", reported_id);
    }

    // 신고 처리
    @PostMapping("/register")
    public String register(ReportVO report, HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        report.setReporter_id(member.getUserid());

        service.report(report);

        rttr.addFlashAttribute("result", "report_success");
        return "redirect:/recipe/get?bno=" + report.getBno();
    }
}