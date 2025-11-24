package org.mnu.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.CommentVO;

public interface CommentMapper {
    public int create(CommentVO vo);
    public List<CommentVO> getListByBno(Long bno);
    void deleteByBno(Long bno);
    public int remove(@Param("comment_id") Long comment_id);
}