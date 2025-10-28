package org.mnu.domain;

import lombok.Data;

@Data
public class NutritionVO {
    private double calories;    // 칼로리 (kcal)
    private double carbohydrate; // 탄수화물 (g)
    private double protein;     // 단백질 (g)
    private double fat;         // 지방 (g)
    // 필요에 따라 나트륨, 당류 등 다른 영양성분 필드를 추가할 수 있습니다.
}