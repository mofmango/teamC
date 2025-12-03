package org.mnu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.mnu.domain.Criteria;
import org.mnu.domain.FreeBoardVO;
import org.mnu.domain.MemberVO;
import org.mnu.domain.RecipeVO;
import org.mnu.service.FreeBoardService;
import org.mnu.service.RecipeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
public class MainController {

    private final RecipeService recipeService;
    private final FreeBoardService freeBoardService;

    @GetMapping({"/", "/main"})
    public String main(HttpSession session, Model model) {

        log.info("====== MAIN PAGE ======");
        MemberVO loginMember = (MemberVO) session.getAttribute("member");
        log.info("[MAIN] session.member = " + loginMember);

        if (loginMember != null) {
            String userid = loginMember.getUserid();
            log.info("[MAIN] login userid = " + userid);

            List<RecipeVO> recommendList = recipeService.recommendByUserIngredients(userid);

            log.info("[MAIN] raw recommendList size = " +
                    (recommendList != null ? recommendList.size() : 0));

            // 최대 10개까지만 메인에 노출
            if (recommendList != null && recommendList.size() > 10) {
                recommendList = recommendList.subList(0, 10);
            }
            model.addAttribute("recommendList", recommendList);
        }

        Criteria bestCri = new Criteria();
        bestCri.setPageNum(1);
        bestCri.setAmount(1);
        bestCri.setSort("likes");
        List<RecipeVO> topLiked = recipeService.getList(bestCri);
        RecipeVO heroRecipe = topLiked != null && !topLiked.isEmpty() ? topLiked.get(0) : null;
        model.addAttribute("heroRecipe", heroRecipe);

        Criteria recentCri = new Criteria();
        recentCri.setPageNum(1);
        recentCri.setAmount(8);
        recentCri.setSort("newest");
        model.addAttribute("recentList", recipeService.getList(recentCri));

        Criteria freeCri = new Criteria();
        freeCri.setPageNum(1);
        freeCri.setAmount(5);
        List<FreeBoardVO> recentFreeList = freeBoardService.getList(freeCri);
        model.addAttribute("recentFreeList", recentFreeList);

        return "home";   // /WEB-INF/views/home.jsp
    }
}