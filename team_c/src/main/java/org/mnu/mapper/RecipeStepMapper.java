package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.RecipeStepVO;

public interface RecipeStepMapper {
    public void create(RecipeStepVO step);
    public List<RecipeStepVO> getListByBno(Long bno);
    public void deleteByBno(Long bno); 
}