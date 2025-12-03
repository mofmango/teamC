package org.mnu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.mnu.domain.FreeReplyVO;
import org.mnu.domain.MemberVO;
import org.mnu.service.FreeReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/replies")
@AllArgsConstructor
@Log4j
public class FreeReplyController {

    private FreeReplyService service;
    @PostMapping(
        value = "/new",
        consumes = "application/json",
        produces = MediaType.TEXT_PLAIN_VALUE
    )
    public ResponseEntity<String> create(
            @RequestBody FreeReplyVO vo,
            HttpSession session) {

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED);
        }

        vo.setReplyer(member.getUserid());

        log.info("free reply register: " + vo);

        int insertCount = service.register(vo);

        return (insertCount == 1)
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @GetMapping(
        value = "/pages/{bno}/{page}.json",
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<List<FreeReplyVO>> getList(
            @PathVariable("bno") Long bno,
            @PathVariable("page") int page) {

        log.info("get free replies list, bno=" + bno + ", page=" + page);

        List<FreeReplyVO> list = service.getList(bno);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @DeleteMapping(
        value = "/{rno}",
        produces = MediaType.TEXT_PLAIN_VALUE
    )
    public ResponseEntity<String> remove(
            @PathVariable("rno") Long rno,
            HttpSession session) {

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>("login_required", HttpStatus.UNAUTHORIZED);
        }

        FreeReplyVO reply = service.get(rno);
        if (reply == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        if (!member.getUserid().equals(reply.getReplyer())) {
            return new ResponseEntity<>("forbidden", HttpStatus.FORBIDDEN);
        }

        boolean removed = service.remove(rno);

        return removed
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}