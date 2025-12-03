package org.mnu.service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Objects;

import org.mnu.domain.Criteria;
import org.mnu.domain.RecipeVO;
import org.mnu.mapper.BookmarkMapper;
import org.mnu.mapper.CommentMapper;
import org.mnu.mapper.LikeMapper;
import org.mnu.mapper.RecipeMapper;
import org.mnu.mapper.RecipeStepMapper;
import org.mnu.mapper.TagMapper;
import org.mnu.mapper.IngredientMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class RecipeServiceImpl implements RecipeService {

    private RecipeMapper recipeMapper;
    private TagMapper tagMapper;
    private CommentMapper commentMapper;
    private LikeMapper likeMapper;
    private BookmarkMapper bookmarkMapper;
    private RecipeStepMapper recipeStepMapper;
    private IngredientMapper ingredientMapper;

    @Transactional
    @Override
    public void register(RecipeVO recipe) {
        log.info("register......" + recipe);
        recipeMapper.create(recipe);

        if (recipe.getSteps() != null) {
            recipe.getSteps().forEach(step -> {
                step.setBno(recipe.getBno());
                recipeStepMapper.create(step);
            });
        }

        if (recipe.getTags() != null && !recipe.getTags().trim().isEmpty()) {
            String[] tagArr = recipe.getTags().split(",");
            for (String tagName : tagArr) {
                tagName = tagName.trim();
                if (!tagName.isEmpty()) {
                    tagMapper.saveTag(tagName);
                    tagMapper.saveRecipeTag(recipe.getBno(), tagName);
                }
            }
        }
    }

    @Override
    public RecipeVO get(Long bno) {
        log.info("get......" + bno);
        RecipeVO recipe = recipeMapper.read(bno);
        if (recipe != null) {
            recipe.setSteps(recipeStepMapper.getListByBno(bno));
        }
        return recipe;
    }

    @Transactional
    @Override
    public boolean modify(RecipeVO recipe) {
        log.info("modify......" + recipe);

        tagMapper.deleteRecipeTagsByBno(recipe.getBno());
        recipeStepMapper.deleteByBno(recipe.getBno());

        if (recipe.getTags() != null && !recipe.getTags().trim().isEmpty()) {
            String[] tagArr = recipe.getTags().split(",");
            for (String tagName : tagArr) {
                tagName = tagName.trim();
                if (!tagName.isEmpty()) {
                    tagMapper.saveTag(tagName);
                    tagMapper.saveRecipeTag(recipe.getBno(), tagName);
                }
            }
        }

        if (recipe.getSteps() != null) {
            recipe.getSteps().forEach(step -> {
                step.setBno(recipe.getBno());
                recipeStepMapper.create(step);
            });
        }

        return recipeMapper.update(recipe) == 1;
    }

    @Transactional
    @Override
    public boolean remove(Long bno) {
        log.info("remove...." + bno);
        commentMapper.deleteByBno(bno);
        likeMapper.deleteByBno(bno);
        bookmarkMapper.deleteByBno(bno);
        tagMapper.deleteRecipeTagsByBno(bno);
        recipeStepMapper.deleteByBno(bno);

        return recipeMapper.delete(bno) == 1;
    }

    @Override
    public List<RecipeVO> getList(Criteria cri) {
        log.info("getList with criteria: " + cri);
        return recipeMapper.getList(cri);
    }

    @Override
    public List<RecipeVO> getListByWriter(String writer) {
        log.info("getList by writer: " + writer);
        return recipeMapper.getListByWriter(writer);
    }

    @Override
    public List<RecipeVO> getBookmarksByUser(String userid) {
        log.info("getBookmarks by user: " + userid);
        return recipeMapper.getBookmarksByUser(userid);
    }

    @Override
    public List<RecipeVO> getLikesByUser(String userid) {
        log.info("getLikes by user: " + userid);
        return recipeMapper.getLikesByUser(userid);
    }

    @Override
    public int getTotalCount(Criteria cri) {
        log.info("getTotalCount with criteria: " + cri);
        return recipeMapper.getTotalCount(cri);
    }

    @Override
    public int countByWriter(String writer) {
        return recipeMapper.countByWriter(writer);
    }

    @Override
    public int countBookmarksByUser(String userid) {
        return recipeMapper.countBookmarksByUser(userid);
    }

    @Override
    public int countLikesByUser(String userid) {
        return recipeMapper.countLikesByUser(userid);
    }

    @Override
    public List<RecipeVO> recommendByUserIngredients(String userid) {
        // 1) 사용자 냉장고 재료 목록 조회
        List<String> ingredients = ingredientMapper.getListByUser(userid);
        log.info("[recommendByUserIngredients] userid = " + userid);
        log.info("[recommendByUserIngredients] raw ingredients = " + ingredients);

        // 2) 기존 List<String> 버전 재사용 (태그 매칭 + 정렬)
        List<RecipeVO> baseList = recommendByUserIngredients(ingredients);

        if (baseList == null || baseList.isEmpty()) {
            log.info("[recommendByUserIngredients] baseList is empty");
            return Collections.emptyList();
        }

        // 3) 본인 레시피(writer == userid) 제외 + 최대 3개만
        List<RecipeVO> filtered = baseList.stream()
                .filter(r -> r.getWriter() != null && !r.getWriter().equals(userid))
                .limit(3)
                .collect(Collectors.toList());

        log.info("[recommendByUserIngredients] filtered(result) size = " + filtered.size());
        return filtered;
    }

    @Override
    public List<RecipeVO> recommendByUserIngredients(List<String> ingredientList) {

        if (ingredientList == null || ingredientList.isEmpty()) {
            log.info("[recommendByUserIngredients] ingredientList is empty");
            return Collections.emptyList();
        }

        // 공백/# 제거 + 중복 제거
        List<String> filtered = ingredientList.stream()
                .filter(Objects::nonNull)
                .map(s -> s.replace("#", "").trim())
                .filter(s -> !s.isEmpty())
                .distinct()
                .collect(Collectors.toList());

        log.info("[recommendByUserIngredients] filtered ingredients = " + filtered);

        if (filtered.isEmpty()) {
            log.info("[recommendByUserIngredients] filtered is empty");
            return Collections.emptyList();
        }

        List<RecipeVO> result = recipeMapper.findByIngredients(filtered);

        log.info("[recommendByUserIngredients] result size = " +
                (result != null ? result.size() : 0));

        return result;
    }

    @Override
    public List<RecipeVO> getMyRecipeList(Criteria cri, String writer) {
        log.info("getMyRecipeList : writer = " + writer + ", cri = " + cri);
        return recipeMapper.getMyRecipeList(cri, writer);
    }

    @Override
    public List<RecipeVO> getMyBookmarkList(Criteria cri, String userid) {
        log.info("getMyBookmarkList : userid = " + userid + ", cri = " + cri);
        return recipeMapper.getMyBookmarkList(cri, userid);
    }

    @Override
    public List<RecipeVO> getMyLikeList(Criteria cri, String userid) {
        log.info("getMyLikeList : userid = " + userid + ", cri = " + cri);
        return recipeMapper.getMyLikeList(cri, userid);
    }

    @Override
    public List<RecipeVO> findByIngredients(List<String> ingredientList) {
        return recipeMapper.findByIngredients(ingredientList);
    }

    // 메인페이지용

    @Override
    public RecipeVO getHeroRecipe() {
        List<RecipeVO> list = getTopLikedList(1);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    @Override
    public List<RecipeVO> getTopLikedList(int limit) {
        Criteria cri = new Criteria();
        cri.setPageNum(1);
        cri.setAmount(limit);
        cri.setSort("likes");
        return recipeMapper.getList(cri);
    }

    @Override
    public List<RecipeVO> getRecentList(int limit) {
        Criteria cri = new Criteria();
        cri.setPageNum(1);
        cri.setAmount(limit);
        cri.setSort(null);
        return recipeMapper.getList(cri);
    }
}