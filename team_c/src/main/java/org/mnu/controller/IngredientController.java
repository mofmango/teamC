package org.mnu.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.mnu.service.IngredientService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/ingredients")
@AllArgsConstructor
public class IngredientController {

    private IngredientService service;

    @GetMapping("/list")
    public ResponseEntity<List<String>> getList(HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); // 로그인 안됨
        }
        return new ResponseEntity<>(service.getList(member.getUserid()), HttpStatus.OK);
    }

    // 새로운 재료 추가
    @PostMapping("/{name}")
    public ResponseEntity<String> addIngredient(@PathVariable("name") String name, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>("로그인이 필요합니다.", HttpStatus.UNAUTHORIZED);
        }
        service.add(member.getUserid(), name);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }

    // 재료 삭제
    @DeleteMapping("/{name}")
    public ResponseEntity<String> removeIngredient(@PathVariable("name") String name, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>("로그인이 필요합니다.", HttpStatus.UNAUTHORIZED);
        }
        service.remove(member.getUserid(), name);
        return new ResponseEntity<>("success", HttpStatus.OK);
    }
}