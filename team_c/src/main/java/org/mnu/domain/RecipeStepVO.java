package org.mnu.domain;

import lombok.Data;

@Data
public class RecipeStepVO {
    private Long step_id;
    private Long bno;
    private Long step_order;
    private String description;
    private String image_path;
}