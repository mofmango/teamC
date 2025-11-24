package org.mnu.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mnu.domain.CommentVO;
import org.mnu.domain.MemberVO;
import org.mnu.service.CommentService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/comment/*")
@AllArgsConstructor
public class CommentController {

    private CommentService service;

    @PostMapping("/register")
    public String register(CommentVO vo,
                           HttpServletRequest req,
                           HttpSession session) {

        // reply -> content 보정
        if (vo.getContent() == null || vo.getContent().trim().isEmpty()) {
            String reply = req.getParameter("reply");
            if (reply != null) vo.setContent(reply);
        }

        // replyer -> userid 보정
        if (vo.getUserid() == null || vo.getUserid().trim().isEmpty()) {
            String replyer = req.getParameter("replyer");
            if (replyer != null) vo.setUserid(replyer);
        }

        // 그래도 없으면 세션 값
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member != null && (vo.getUserid() == null || vo.getUserid().trim().isEmpty())) {
            vo.setUserid(member.getUserid());
        }

        log.info("댓글 등록 vo = " + vo);
        service.register(vo);

        return "redirect:/recipe/get?bno=" + vo.getBno();
    }

    // ✅ 댓글 단건 삭제 AJAX
    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> remove(
            @RequestParam("comment_id") Long commentId,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            result.put("success", false);
            result.put("message", "login_required");
            return ResponseEntity.status(401).body(result);
        }

        boolean ok = service.remove(commentId);
        result.put("success", ok);

        return ResponseEntity.ok(result);
    }
}