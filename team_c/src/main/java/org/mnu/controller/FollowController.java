package org.mnu.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.mnu.service.FollowService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/follow")
@AllArgsConstructor
public class FollowController {
    private FollowService service;

    @PostMapping("/{followingId}")
    public ResponseEntity<Map<String, Object>> toggleFollow(@PathVariable("followingId") String followingId, HttpSession session) {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        boolean isFollowing = service.toggleFollow(member.getUserid(), followingId);

        Map<String, Object> result = new HashMap<>();
        result.put("isFollowing", isFollowing);

        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}