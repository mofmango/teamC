package org.mnu.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.mnu.service.BookmarkService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/bookmark")
@AllArgsConstructor
public class BookmarkController {
    
    private BookmarkService service;

    @PostMapping("/{bno}")
    public ResponseEntity<Map<String, Object>> toggleBookmark(@PathVariable("bno") Long bno, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); // 401: 로그인 필요
        }
        
        boolean isBookmarked = service.toggleBookmark(bno, member.getUserid());
        
        Map<String, Object> result = new HashMap<>();
        result.put("userBookmarked", isBookmarked);
        
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}