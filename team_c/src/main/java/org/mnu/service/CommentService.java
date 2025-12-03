package org.mnu.service;

import java.util.List;
import org.mnu.domain.CommentVO;

public interface CommentService {
    int register(CommentVO vo);
    List<CommentVO> getList(Long bno);
    boolean remove(Long comment_id);
}