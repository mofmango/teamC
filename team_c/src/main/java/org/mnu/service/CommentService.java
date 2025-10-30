package org.mnu.service;

import java.util.List;
import org.mnu.domain.CommentVO;

public interface CommentService {
    public int register(CommentVO vo);
    public List<CommentVO> getList(Long bno);
}