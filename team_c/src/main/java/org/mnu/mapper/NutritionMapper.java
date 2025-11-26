package org.mnu.mapper;

import org.mnu.domain.NutritionVO;


public interface NutritionMapper {

    public NutritionVO selectByRecipeId(Long recipeId);


    public int insert(NutritionVO vo);


    public int updateByRecipeId(NutritionVO vo);


    public int existsByRecipeId(Long recipeId);
}