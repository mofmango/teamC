package org.mnu.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;
import javax.servlet.http.HttpSession;

import org.mnu.domain.Criteria;
import org.mnu.domain.MemberVO;
import org.mnu.domain.RecipeStepVO;
import org.mnu.domain.RecipeVO;
import org.mnu.service.CommentService;
import org.mnu.service.FollowService;
import org.mnu.service.NutritionService;
import org.mnu.service.RecipeService;
import org.mnu.service.TagService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.JsonObject;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/recipe/*")
@AllArgsConstructor
public class RecipeController {
    
    private RecipeService service;
    private TagService tagService;
    private CommentService commentService;
    private FollowService followService;
    private NutritionService nutritionService;

    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list with criteria: " + cri);
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("cri", cri);
    }

    @GetMapping("/register")
    public void register() {
        log.info("====== 단계별 레시피 등록 페이지로 이동 ======");
    }

    @PostMapping("/register")
    public String register(RecipeVO recipe, 
                         @RequestParam("uploadFile") MultipartFile uploadFile, 
                         @RequestParam("stepImages") List<MultipartFile> stepImages, 
                         HttpSession session, 
                         RedirectAttributes rttr) {
        log.info("====== 단계별 레시피 등록 처리 ======");

        MemberVO member = (MemberVO) session.getAttribute("member");
        recipe.setWriter(member.getUserid());

        String uploadFolder = "/Users/mof/upload"; // macOS 경로

        // 대표 이미지 저장
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String originalFileName = uploadFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedFileName = uuid + "_" + originalFileName;
            File saveFile = new File(uploadFolder, savedFileName);
            
            try {
                uploadFile.transferTo(saveFile);
                recipe.setImage_path("/uploads/" + savedFileName);
            } catch (Exception e) {
                log.error("Main file upload error", e);
            }
        }

        // 단계별 이미지 저장
        List<RecipeStepVO> steps = recipe.getSteps();
        if (steps != null && stepImages != null && steps.size() == stepImages.size()) {
            for (int i = 0; i < steps.size(); i++) {
                MultipartFile stepFile = stepImages.get(i);
                if (stepFile != null && !stepFile.isEmpty()) {
                    String originalStepFileName = stepFile.getOriginalFilename();
                    String uuid = UUID.randomUUID().toString();
                    String savedStepFileName = uuid + "_" + originalStepFileName;
                    File saveStepFile = new File(uploadFolder, savedStepFileName);
                    
                    try {
                        stepFile.transferTo(saveStepFile);
                        steps.get(i).setImage_path("/uploads/" + savedStepFileName);
                    } catch (Exception e) {
                        log.error("Step file upload error", e);
                    }
                }
            }
        }

        // 1) 레시피 DB 저장
        service.register(recipe);

        // 2) 영양성분 계산 + TBL_NUTRITION 업서트
        //    - 여기서만 Gemini 호출
        //    - ING_HASH 비교로 같은 재료면 나중에는 다시 호출 안 함
        if (recipe.getIngredients() != null) {
            nutritionService.upsertForRecipe(recipe.getBno(), recipe.getIngredients());
        }

        rttr.addFlashAttribute("result", recipe.getBno());
        return "redirect:/recipe/list";
    }
    
    @GetMapping("/get")
    public void get(@RequestParam("bno") Long bno, Model model, HttpSession session) {
        log.info("====== 레시피 상세 조회 페이지 ======");

        RecipeVO recipe = service.get(bno);
        model.addAttribute("recipe", recipe);
        model.addAttribute("commentList", commentService.getList(bno));
        model.addAttribute("tagList", tagService.getTagsByBno(bno));

        if (recipe != null) {
            // ❌ 예전: 매 조회마다 Gemini 호출
            // model.addAttribute("nutrition", nutritionService.getNutritionInfo(recipe.getIngredients()));

            // ✅ 이제는 DB에 저장된 영양성분만 조회 (TBL_NUTRITION)
            model.addAttribute("nutrition", nutritionService.getByRecipeId(bno));

            MemberVO loginUser = (MemberVO) session.getAttribute("member");
            if (loginUser != null) {
                boolean isFollowing = followService.isFollowing(loginUser.getUserid(), recipe.getWriter());
                model.addAttribute("isFollowing", isFollowing);
            }
        }
    }

    
    @GetMapping("/modify")
    public void modify(@RequestParam("bno") Long bno, Model model) {
        log.info("====== 레시피 수정 페이지로 이동 ======");
        RecipeVO recipe = service.get(bno);
        model.addAttribute("recipe", recipe);
        model.addAttribute("tagString", String.join(",", tagService.getTagsByBno(bno)));
    }
    
    @PostMapping("/modify")
    public String modify(RecipeVO recipe, MultipartFile uploadFile, RedirectAttributes rttr) {
        log.info("====== 레시피 수정 처리 ======");
        
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String uploadFolder = "/Users/mof/upload";
            String originalFileName = uploadFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedFileName = uuid + "_" + originalFileName;
            File saveFile = new File(uploadFolder, savedFileName);
            try {
                uploadFile.transferTo(saveFile);
                recipe.setImage_path("/uploads/" + savedFileName);
            } catch (Exception e) {
                log.error("File upload error", e);
            }
        }

        if (service.modify(recipe)) {
            rttr.addFlashAttribute("result", "success");

            // 수정 시에도 재료가 바뀌었으면 영양성분 다시 계산해서 DB 갱신
            if (recipe.getIngredients() != null) {
                nutritionService.upsertForRecipe(recipe.getBno(), recipe.getIngredients());
            }
        }
        return "redirect:/recipe/list";
    }
    
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
        log.info("====== 레시피 삭제 처리 ======");
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        return "redirect:/recipe/list";
    }
    
    @PostMapping(value="/uploadSummernoteImageFile", produces = "application/json")
    @ResponseBody
    public ResponseEntity<JsonObject> uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) {
        JsonObject jsonObject = new JsonObject();
        String uploadFolder = "/Users/mof/upload";
        String originalFileName = multipartFile.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String savedFileName = uuid + "_" + originalFileName;
        File saveFile = new File(uploadFolder, savedFileName);
        try {
            multipartFile.transferTo(saveFile);
            jsonObject.addProperty("url", "/uploads/" + savedFileName);
            jsonObject.addProperty("responseCode", "success");
        } catch (Exception e) {
            jsonObject.addProperty("responseCode", "error");
            log.error("File upload error", e);
        }
        return new ResponseEntity<>(jsonObject, HttpStatus.OK);
    }
}