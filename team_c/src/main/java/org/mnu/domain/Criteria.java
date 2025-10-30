package org.mnu.domain;

import lombok.Data;

@Data
public class Criteria {
    private String category;
    private String sort;
    private String type;
    private String keyword;
    private String tag;
}