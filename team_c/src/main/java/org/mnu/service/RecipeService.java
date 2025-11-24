package org.mnu.service;

import java.util.List;
import org.mnu.domain.Criteria; // Criteria 임포트
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
    
    // [마이페이지] 내 레시피 페이징
    public List<RecipeVO> getMyRecipeList(Criteria cri, String writer);

    // [마이페이지] 북마크 페이징
    public List<RecipeVO> getMyBookmarkList(Criteria cri, String userid);

    // [마이페이지] 좋아요 페이징
    public List<RecipeVO> getMyLikeList(Criteria cri, String userid);
    
    public List<RecipeVO> findByIngredients(List<String> ingredientList);
    

    
}