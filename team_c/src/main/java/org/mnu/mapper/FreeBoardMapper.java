package org.mnu.mapper;

import java.util.List;

import org.mnu.domain.Criteria;
import org.mnu.domain.FreeBoardVO;

public interface FreeBoardMapper {


    public List<FreeBoardVO> getList(Criteria cri);

    public void create(FreeBoardVO board);

    public FreeBoardVO read(Long bno);

    public int delete(Long bno);

    public int update(FreeBoardVO board);


    public int getTotalCount();
}