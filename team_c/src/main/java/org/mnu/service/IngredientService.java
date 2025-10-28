package org.mnu.service;

import java.util.List;

public interface IngredientService {
    public List<String> getList(String userid);
    public void add(String userid, String name);
    public void remove(String userid, String name);
}