package org.mnu.service;

import org.mnu.domain.NutritionVO;

public interface NutritionService {
    NutritionVO getNutritionInfo(String ingredients);

    // 레시피 상세 조회 시: DB에서 영양성분 읽어오기 (Gemini 호출 없음)
    NutritionVO getByRecipeId(Long recipeId);

    // 레시피 작성/수정 시: Gemini 호출 + TBL_NUTRITION 업서트
    NutritionVO upsertForRecipe(Long recipeId, String ingredients);
}