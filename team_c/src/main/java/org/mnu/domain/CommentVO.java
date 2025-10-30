package org.mnu.domain;

import java.util.Date;

public class CommentVO {
    private Long comment_id;   // PK
    private Long bno;          // 레시피 번호 FK
    private String userid;     // 작성자
    private String content;    // 댓글 내용
    private Date regdate;      // 작성일

    public Long getComment_id() {
        return comment_id;
    }
    public void setComment_id(Long comment_id) {
        this.comment_id = comment_id;
    }

    public Long getBno() {
        return bno;
    }
    public void setBno(Long bno) {
        this.bno = bno;
    }

    public String getUserid() {
        return userid;
    }
    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public Date getRegdate() {
        return regdate;
    }
    public void setRegdate(Date regdate) {
        this.regdate = regdate;
    }
}