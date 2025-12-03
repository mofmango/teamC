package org.mnu.domain;

import java.util.Date;

import lombok.Data;

@Data
public class NutritionVO {
	private Long recipeId;

    // 총 칼로리 (kcal)
    private Double calories;

    // 탄수화물 (g)
    private Double carbohydrate;

    // 단백질 (g)
    private Double protein;

    //지방 (g)
    private Double fat;

    // 재료 문자열(및 인분 정보)
    private String ingHash;

    // 영양 성분이 계산된 시각
    private Date computedAt;
}