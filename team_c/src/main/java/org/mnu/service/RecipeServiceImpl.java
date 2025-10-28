package org.mnu.service;

import java.util.List;
import org.mnu.domain.Criteria;
import org.mnu.domain.RecipeVO;
import org.mnu.mapper.BookmarkMapper;
import org.mnu.mapper.CommentMapper;
import org.mnu.mapper.LikeMapper;
import org.mnu.mapper.RecipeMapper;
import org.mnu.mapper.RecipeStepMapper;
import org.mnu.mapper.TagMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.mnu.mapper.IngredientMapper;
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
        List<String> ingredients = ingredientMapper.getListByUser(userid);
        if (ingredients == null || ingredients.isEmpty()) {
            return new java.util.ArrayList<>();
        }
        return recipeMapper.findByIngredients(ingredients);
    }
    
    
    
}