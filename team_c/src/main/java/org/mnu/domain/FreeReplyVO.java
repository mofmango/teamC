package org.mnu.domain;

import java.util.Date;

public class FreeReplyVO {

    private Long rno;        // 댓글 번호
    private Long bno;        // 자유게시판 글 번호
    private String reply;    // 댓글 내용
    private String replyer;  // 작성자 ID
    private Date replyDate;  // 작성일 (replydate 컬럼 매핑)

    public Long getRno() {
        return rno;
    }

    public void setRno(Long rno) {
        this.rno = rno;
    }

    public Long getBno() {
        return bno;
    }

    public void setBno(Long bno) {
        this.bno = bno;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getReplyer() {
        return replyer;
    }

    public void setReplyer(String replyer) {
        this.replyer = replyer;
    }

    public Date getReplyDate() {
        return replyDate;
    }

    public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
    }
}