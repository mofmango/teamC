package org.mnu.domain;

import lombok.Data;

@Data
public class Criteria {
    // 현재 페이지 번호 (1부터 시작)
    private int pageNum;

    // 한 페이지에 보여줄 게시글 수
    private int amount;
    
    private String category;
    private String sort;
    private String type;
    private String keyword;
    private String tag;
    
    // 기본 생성자: 1페이지, 10개씩
    public Criteria() {
        this(1, 10);
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }

    // Oracle ROWNUM 페이징용 시작/끝 번호
    public int getStartRow() {
        return (pageNum - 1) * amount + 1;
    }

    public int getEndRow() {
        return pageNum * amount;
    }
}