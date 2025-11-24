package org.mnu.controller;

import javax.servlet.http.HttpSession;
import org.mnu.domain.FreeBoardVO;
import org.mnu.domain.MemberVO;
import org.mnu.domain.Criteria;
import org.mnu.domain.PageDTO;
import org.mnu.service.FreeBoardService;
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
@RequestMapping("/free/*")
@AllArgsConstructor
public class FreeBoardController {

    private FreeBoardService service;

    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("====== 자유 게시판 목록 ====== " + cri);

        if (cri.getPageNum() == 0) {
            cri.setPageNum(1);
        }
        if (cri.getAmount() == 0) {
            cri.setAmount(10);   // 한 페이지 10개
        }

        model.addAttribute("list", service.getList(cri));
        model.addAttribute("cri", cri);

        int total = service.getTotalCount();
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }

    @GetMapping("/register")
    public void register() {
        log.info("====== 자유 게시판 등록 페이지로 이동 ======");
    }

    @PostMapping("/register")
    public String register(FreeBoardVO board, HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        board.setWriter(member.getUserid());
        service.register(board);
        rttr.addFlashAttribute("result", board.getBno());
        return "redirect:/free/list";
    }

    @GetMapping("/get")
    public void get(@RequestParam("bno") Long bno, Model model) {
        log.info("====== 자유 게시판 상세 조회 ======");
        model.addAttribute("board", service.get(bno));
    }

    @GetMapping("/modify")
    public void modify(@RequestParam("bno") Long bno, Model model) {
        log.info("====== 자유 게시판 수정 페이지로 이동 ======");
        model.addAttribute("board", service.get(bno));
    }

    @PostMapping("/modify")
    public String modify(FreeBoardVO board, RedirectAttributes rttr) {
        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/free/list";
    }

    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/free/list";
    }
}