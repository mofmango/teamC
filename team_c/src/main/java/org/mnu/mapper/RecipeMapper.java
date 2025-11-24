package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.Criteria;
import org.apache.ibatis.annotations.Param;
import org.mnu.domain.RecipeVO;

public interface RecipeMapper {
    // 전체 레시피 목록 조회
    // public List<RecipeVO> getList();
	public List<RecipeVO> getList(Criteria cri);
    // 레시피 등록
    public void create(RecipeVO recipe);
    
    // 특정 레시피 조회
    public RecipeVO read(Long bno);
    
    // 레시피 삭제
    public int delete(Long bno);
    
    // 레시피 수정
    public int update(RecipeVO recipe);
    
    // 레시피 검색 
    public List<RecipeVO> getList(String keyword);
    
    
    public List<RecipeVO> getListByWriter(String writer);
    // 좋아요 수 업데이트 메서드
    public void updateLikeCount(@Param("bno") Long bno, @Param("amount") int amount);
    
    public List<RecipeVO> getMyRecipeList(
            @Param("cri") Criteria cri,
            @Param("writer") String writer);
    public List<RecipeVO> getMyBookmarkList(
            @Param("cri") Criteria cri,
            @Param("userid") String userid);
    
    public List<RecipeVO> getMyLikeList(
            @Param("cri") Criteria cri,
            @Param("userid") String userid);

    
    
    public List<RecipeVO> getBookmarksByUser(String userid);
    
    
    public List<RecipeVO> getLikesByUser(String userid);
    
    
    public int countByWriter(String writer);
    
    public int countBookmarksByUser(String userid);
    
    public int countLikesByUser(String userid);
    
    public List<RecipeVO> findByIngredients(@Param("ingredientList") List<String> ingredientList);
    

    public int getTotalCount(Criteria cri);
    
    
}