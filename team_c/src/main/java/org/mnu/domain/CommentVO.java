package org.mnu.domain;

import java.util.Date;
import lombok.Data;

@Data
public class CommentVO {
    private Long rno, bno;
    private String reply, replyer;
    private Date replyDate, updateDate;
}