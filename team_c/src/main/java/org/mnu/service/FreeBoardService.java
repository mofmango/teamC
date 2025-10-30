package org.mnu.service;

import java.util.List;
import org.mnu.domain.FreeBoardVO;

public interface FreeBoardService {

    public void register(FreeBoardVO board);

    public FreeBoardVO get(Long bno);

    public boolean modify(FreeBoardVO board);

    public boolean remove(Long bno);

    public List<FreeBoardVO> getList();

}