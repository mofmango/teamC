package org.mnu.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface IngredientMapper {
    public List<String> getListByUser(String userid);

    public void addIngredient(@Param("userid") String userid, @Param("name") String name);

    public void removeIngredient(@Param("userid") String userid, @Param("name") String name);
}