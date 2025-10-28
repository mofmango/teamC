package org.mnu.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class RecipeVO {
    private Long bno;
    private String title;
    private String writer;
    
    private String writerName;
    
    private Long cost;
    private String time_required;
    private String ingredients;
    private String image_path;
    private int like_count;
    private String tags;

    private List<RecipeStepVO> steps;
    private Date regdate;
    private Date updatedate;
    
}