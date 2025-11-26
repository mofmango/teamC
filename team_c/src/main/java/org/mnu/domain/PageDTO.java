package org.mnu.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

    private int startPage;   // 현재 블럭의 시작 페이지 번호
    private int endPage;     // 현재 블럭의 끝 페이지 번호
    private boolean prev;    // 이전 블럭 존재 여부
    private boolean next;    // 다음 블럭 존재 여부

    private int total;       // 전체 게시글 수
    private Criteria cri;    // 현재 Criteria (pageNum, amount, 검색조건 등)

    public PageDTO(Criteria cri, int total) {
        this.cri = cri;
        this.total = total;

        int pageCountPerBlock = 10; // 한 번에 보여줄 페이지 번호 개수

        // ex) pageNum = 7이면 1~10,  pageNum = 11이면 11~20 이런 식
        this.endPage = (int) (Math.ceil(cri.getPageNum() / (double) pageCountPerBlock)) * pageCountPerBlock;
        this.startPage = this.endPage - pageCountPerBlock + 1;

        // 실제 마지막 페이지 번호
        int realEnd = (int) Math.ceil((total * 1.0) / cri.getAmount());

        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;
    }
}