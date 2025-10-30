package org.mnu.controller;

import org.mnu.domain.MemberVO;
import org.mnu.service.FollowService;
import org.mnu.service.MemberService;
import org.mnu.service.RecipeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Controller
@Log4j
@RequestMapping("/member/*")
public class MemberController {

    @Setter(onMethod_ = @Autowired)
    private MemberService service;
    
    @Setter(onMethod_ = @Autowired)
    private RecipeService recipeService;
    
    // FollowService 의존성 주입 추가
    @Setter(onMethod_ = @Autowired)
    private FollowService followService;

    // 회원가입 페이지로 이동
    @GetMapping("/join")
    public void join() {
        log.info("====== 회원가입 페이지로 이동 ======");
    }

    // 회원가입 처리
    @PostMapping("/join")
    public String join(MemberVO member, RedirectAttributes rttr) {
        log.info("====== 회원가입 처리 ======");
        log.info("가입 정보: " + member);
        
        service.join(member);
        
        rttr.addFlashAttribute("result", "join_success");
        return "redirect:/recipe/list";
    }
    
    @GetMapping("/login")
    public void login() {
        log.info("====== 로그인 페이지로 이동 ======");
    }
    
    @PostMapping("/login")
    public String login(MemberVO member, HttpServletRequest request, RedirectAttributes rttr) {
        log.info("====== 로그인 처리 ======");
        MemberVO loginMember = service.login(member);
        
        if (loginMember != null) {
            HttpSession session = request.getSession();
            session.setAttribute("member", loginMember);
            return "redirect:/recipe/list";
        } else {
            rttr.addFlashAttribute("result", "login_fail");
            return "redirect:/member/login";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        log.info("====== 로그아웃 처리 ======");
        session.invalidate();
        return "redirect:/recipe/list";
    }
    
    @GetMapping("/mypage")
    public void mypage(HttpSession session, Model model) {
        log.info("====== 마이페이지로 이동 ======");
        MemberVO member = (MemberVO) session.getAttribute("member");
        if(member != null) {
            String userid = member.getUserid();
            model.addAttribute("postCount", recipeService.countByWriter(userid));
            model.addAttribute("bookmarkCount", recipeService.countBookmarksByUser(userid));
            model.addAttribute("likeCount", recipeService.countLikesByUser(userid));
            model.addAttribute("followerCount", followService.getFollowerCount(userid));
            model.addAttribute("followingCount", followService.getFollowingCount(userid));
        }
    }
    // 팔로워 목록 페이지를 보여주는 메서드 추가
    @GetMapping("/followers")
    public String followers(@RequestParam("userid") String userid, Model model) {
        model.addAttribute("userList", followService.getFollowerList(userid));
        model.addAttribute("title", "팔로워 목록");
        return "/member/followList"; // followers.jsp 대신 공통으로 사용할 followList.jsp를 가리킴
    }
    
    // 팔로잉 목록 페이지를 보여주는 메서드 추가
    @GetMapping("/following")
    public String following(@RequestParam("userid") String userid, Model model) {
        model.addAttribute("userList", followService.getFollowingList(userid));
        model.addAttribute("title", "팔로잉 목록");
        return "/member/followList"; // following.jsp 대신 공통으로 사용할 followList.jsp를 가리킴
    }
    
    @GetMapping("/userpage")
    public String userpage(@RequestParam("userid") String userid, Model model, HttpSession session) {
        log.info("====== " + userid + "님의 페이지로 이동 ======");

        // 1. 페이지 주인의 정보를 가져옴
        model.addAttribute("pageOwner", service.get(userid));

        // 2. 페이지 주인이 쓴 글 목록
        model.addAttribute("myList", recipeService.getListByWriter(userid));

        // 3. 페이지 주인의 팔로워/팔로잉 수
        model.addAttribute("followerCount", followService.getFollowerCount(userid));
        model.addAttribute("followingCount", followService.getFollowingCount(userid));
        
        // 4. 현재 로그인한 사용자가 이 페이지 주인을 팔로우하고 있는지 여부
        MemberVO loginUser = (MemberVO) session.getAttribute("member");
        if (loginUser != null) {
            boolean isFollowing = followService.isFollowing(loginUser.getUserid(), userid);
            model.addAttribute("isFollowing", isFollowing);
        }

        return "/member/userpage";
    }
    
    @GetMapping("/myposts")
    public String myposts(String userid, Model model) {
        model.addAttribute("list", recipeService.getListByWriter(userid));
        return "/member/myPostList";
    }

    @GetMapping("/mybookmarks")
    public String mybookmarks(String userid, Model model) {
        model.addAttribute("list", recipeService.getBookmarksByUser(userid));
        return "/member/bookmarkList";
    }

    @GetMapping("/mylikes")
    public String mylikes(String userid, Model model) {
        model.addAttribute("list", recipeService.getLikesByUser(userid));
        return "/member/likeList";
    }
    
    @GetMapping("/myfridge")
    public void myfridge(HttpSession session, Model model) {
        log.info("====== 나의 냉장고 페이지로 이동 ======");
        MemberVO member = (MemberVO) session.getAttribute("member");
        if(member != null) {
            model.addAttribute("recommendList", recipeService.recommendByUserIngredients(member.getUserid()));
        }
    }
    
    
}