package org.mnu.mapper;

import org.apache.ibatis.annotations.Param;

public interface TagMapper {
    // TBL_TAG에 태그 저장 (이미 존재하면 무시)
    public void saveTag(String tagName);
    
    // TBL_RECIPE_TAG에 관계 저장
    public void saveRecipeTag(@Param("bno") Long bно, @Param("tagName") String tagName);
    
    // 특정 게시글의 태그 목록 조회
    public java.util.List<String> getTagsByBno(Long bno);
    
    public void deleteRecipeTagsByBno(Long bno);
}