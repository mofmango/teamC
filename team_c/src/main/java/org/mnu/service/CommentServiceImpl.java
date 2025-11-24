package org.mnu.service;

import java.util.List;

import org.mnu.domain.CommentVO;
import org.mnu.mapper.CommentMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CommentServiceImpl implements CommentService {

    private CommentMapper mapper;

    @Override
    public int register(CommentVO vo) {
        return mapper.create(vo);
    }

    @Override
    public List<CommentVO> getList(Long bno) {
        return mapper.getListByBno(bno);
    }

    @Override
    public boolean remove(Long comment_id) {
        return mapper.remove(comment_id) == 1;
    }
}