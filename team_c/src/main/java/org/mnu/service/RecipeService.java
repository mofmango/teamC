package org.mnu.service;

import java.util.List;
import org.mnu.domain.Criteria;
import org.mnu.domain.RecipeVO;

public interface RecipeService {

    public void register(RecipeVO recipe);

    public RecipeVO get(Long bno);

    public boolean modify(RecipeVO recipe);

    public boolean remove(Long bno);

    public List<RecipeVO> getList(Criteria cri);

    public List<RecipeVO> getListByWriter(String writer);

    public List<RecipeVO> getBookmarksByUser(String userid);

    public List<RecipeVO> getLikesByUser(String userid);

    public int countByWriter(String writer);

    public int countBookmarksByUser(String userid);

    public int countLikesByUser(String userid);

    public List<RecipeVO> recommendByUserIngredients(String userid);
    public List<RecipeVO> recommendByUserIngredients(List<String> ingredientList);

    public int getTotalCount(Criteria cri);

    public List<RecipeVO> getMyRecipeList(Criteria cri, String writer);

    public List<RecipeVO> getMyBookmarkList(Criteria cri, String userid);

    public List<RecipeVO> getMyLikeList(Criteria cri, String userid);

    public List<RecipeVO> findByIngredients(List<String> ingredientList);

    // =========================
    // ✅ 메인페이지용
    // =========================
    public RecipeVO getHeroRecipe();                 // 좋아요 1등
    public List<RecipeVO> getTopLikedList(int limit);// 좋아요 TOP N
    public List<RecipeVO> getRecentList(int limit);  // 최신 N
}