package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.Criteria;
import org.apache.ibatis.annotations.Param;
import org.mnu.domain.RecipeVO;

public interface RecipeMapper {

    // 전체 레시피 목록 조회 (페이징/검색/정렬 포함)
    public List<RecipeVO> getList(Criteria cri);

    // 레시피 등록
    public void create(RecipeVO recipe);

    // 특정 레시피 조회
    public RecipeVO read(Long bno);

    // 레시피 삭제
    public int delete(Long bno);

    // 레시피 수정
    public int update(RecipeVO recipe);

    // 작성자별 목록
    public List<RecipeVO> getListByWriter(String writer);

    // 좋아요 수 업데이트
    public void updateLikeCount(@Param("bno") Long bno, @Param("amount") int amount);

    // 마이페이지/유저페이지 페이징
    public List<RecipeVO> getMyRecipeList(
            @Param("cri") Criteria cri,
            @Param("writer") String writer);

    public List<RecipeVO> getMyBookmarkList(
            @Param("cri") Criteria cri,
            @Param("userid") String userid);

    public List<RecipeVO> getMyLikeList(
            @Param("cri") Criteria cri,
            @Param("userid") String userid);

    // 북마크/좋아요 전체 조회
    public List<RecipeVO> getBookmarksByUser(String userid);

    public List<RecipeVO> getLikesByUser(String userid);

    // 카운트
    public int countByWriter(String writer);

    public int countBookmarksByUser(String userid);

    public int countLikesByUser(String userid);

    // 재료 추천용
    public List<RecipeVO> findByIngredients(@Param("ingredientList") List<String> ingredientList);

    // 전체 개수 (검색 조건 포함)
    public int getTotalCount(Criteria cri);
}