package org.mnu.service;

import java.util.List;
import org.mnu.domain.FreeBoardVO;
import org.mnu.mapper.FreeBoardMapper;
import org.springframework.stereotype.Service;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class FreeBoardServiceImpl implements FreeBoardService {

    private FreeBoardMapper mapper;

    @Override
    public void register(FreeBoardVO board) {
        log.info("register......" + board);
        mapper.create(board);
    }

    @Override
    public FreeBoardVO get(Long bno) {
        log.info("get......" + bno);
        return mapper.read(bno);
    }

    @Override
    public boolean modify(FreeBoardVO board) {
        log.info("modify......" + board);
        return mapper.update(board) == 1;
    }

    @Override
    public boolean remove(Long bno) {
        log.info("remove...." + bno);
        return mapper.delete(bno) == 1;
    }

    @Override
    public List<FreeBoardVO> getList() {
        log.info("getList..........");
        return mapper.getList();
    }
}