package org.mnu.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.mnu.service.LikeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/like")
@AllArgsConstructor
public class LikeController {

    private LikeService service;

    @PostMapping("/{bno}")
    public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable("bno") Long bno, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); // 401: 로그인 필요
        }
        
        service.toggleLike(bno, member.getUserid());
        
        int likeCount = service.getLikeCount(bno);
        boolean userLiked = service.hasUserLiked(bno, member.getUserid());

        Map<String, Object> result = new HashMap<>();
        result.put("likeCount", likeCount);
        result.put("userLiked", userLiked);
        
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}