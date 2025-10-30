package org.mnu.service;

import java.util.List;
import org.mnu.mapper.IngredientMapper;
import org.springframework.stereotype.Service;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class IngredientServiceImpl implements IngredientService {

    private IngredientMapper mapper;

    @Override
    public List<String> getList(String userid) {
        return mapper.getListByUser(userid);
    }

    @Override
    public void add(String userid, String name) {
        mapper.addIngredient(userid, name);
    }

    @Override
    public void remove(String userid, String name) {
        mapper.removeIngredient(userid, name);
    }
}