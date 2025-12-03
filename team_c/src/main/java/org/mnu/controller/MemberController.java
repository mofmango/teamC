package org.mnu.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mnu.domain.Criteria;
import org.mnu.domain.MemberVO;
import org.mnu.domain.PageDTO;
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
        return "redirect:/";
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
            log.info("[LOGIN] session id = " + session.getId());
            log.info("[LOGIN] save member = " + loginMember);
            return "redirect:/";
        } else {
            rttr.addFlashAttribute("result", "login_fail");
            return "redirect:/member/login";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        log.info("====== 로그아웃 처리 ======");
        session.invalidate();
        return "redirect:/";
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

    // 팔로워 목록
    @GetMapping("/followers")
    public String followers(@RequestParam("userid") String userid, Model model) {
        model.addAttribute("userList", followService.getFollowerList(userid));
        model.addAttribute("title", "팔로워 목록");
        return "/member/followList";
    }
    
    // 팔로잉 목록
    @GetMapping("/following")
    public String following(@RequestParam("userid") String userid, Model model) {
        model.addAttribute("userList", followService.getFollowingList(userid));
        model.addAttribute("title", "팔로잉 목록");
        return "/member/followList";
    }
    
    // 다른 사람 유저 페이지
    @GetMapping("/userpage")
    public String userpage(@RequestParam("userid") String userid,
                           Criteria cri,
                           Model model,
                           HttpSession session) {

        log.info("====== " + userid + "님의 페이지로 이동 ======");
        
        userid = userid.trim();
        if (cri.getPageNum() == 0) cri.setPageNum(1);
        if (cri.getAmount() == 0) cri.setAmount(10);

        model.addAttribute("pageOwner", service.get(userid));

        model.addAttribute("myList", recipeService.getMyRecipeList(cri, userid));

        int total = recipeService.countByWriter(userid);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("cri", cri);

        // 팔로워/팔로잉 수
        model.addAttribute("followerCount", followService.getFollowerCount(userid));
        model.addAttribute("followingCount", followService.getFollowingCount(userid));

        // 팔로우 여부
        MemberVO loginUser = (MemberVO) session.getAttribute("member");
        if (loginUser != null) {
            boolean isFollowing = followService.isFollowing(loginUser.getUserid(), userid);
            model.addAttribute("isFollowing", isFollowing);
        }

        return "/member/userpage";
    }

    @GetMapping("/myposts")
    public String myposts(Criteria cri, HttpSession session, Model model, RedirectAttributes rttr) {
        log.info("====== 내가 작성한 레시피 목록(페이징) ======");

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            rttr.addFlashAttribute("result", "login_required");
            return "redirect:/member/login";
        }
        String userid = member.getUserid();

        // 기본값 세팅
        if (cri.getPageNum() == 0) cri.setPageNum(1);
        if (cri.getAmount() == 0) cri.setAmount(10);

        int total = recipeService.countByWriter(userid);
        model.addAttribute("list", recipeService.getMyRecipeList(cri, userid));
        model.addAttribute("cri", cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("userid", userid);

        return "/member/myPostList";
    }

    @GetMapping("/mybookmarks")
    public String mybookmarks(Criteria cri, HttpSession session, Model model, RedirectAttributes rttr) {
        log.info("====== 내가 북마크한 레시피 목록(페이징) ======");

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            rttr.addFlashAttribute("result", "login_required");
            return "redirect:/member/login";
        }
        String userid = member.getUserid();

        if (cri.getPageNum() == 0) cri.setPageNum(1);
        if (cri.getAmount() == 0) cri.setAmount(10);

        int total = recipeService.countBookmarksByUser(userid);
        model.addAttribute("list", recipeService.getMyBookmarkList(cri, userid));
        model.addAttribute("cri", cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("userid", userid);

        return "/member/bookmarkList";
    }

    @GetMapping("/mylikes")
    public String mylikes(Criteria cri, HttpSession session, Model model, RedirectAttributes rttr) {
        log.info("====== 내가 좋아요 누른 레시피 목록(페이징) ======");

        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            rttr.addFlashAttribute("result", "login_required");
            return "redirect:/member/login";
        }
        String userid = member.getUserid();

        if (cri.getPageNum() == 0) cri.setPageNum(1);
        if (cri.getAmount() == 0) cri.setAmount(10);

        int total = recipeService.countLikesByUser(userid);
        model.addAttribute("list", recipeService.getMyLikeList(cri, userid));
        model.addAttribute("cri", cri);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("userid", userid);

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