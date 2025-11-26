package org.mnu.service;

import java.util.List;

import org.mnu.domain.FreeReplyVO;
import org.mnu.mapper.FreeReplyMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class FreeReplyServiceImpl implements FreeReplyService {

    private FreeReplyMapper mapper;

    @Override
    public int register(FreeReplyVO vo) {
        log.info("register free reply..." + vo);
        return mapper.insert(vo);
    }

    @Override
    public FreeReplyVO get(Long rno) {
        log.info("get free reply..." + rno);
        return mapper.read(rno);
    }

    @Override
    public boolean remove(Long rno) {
        log.info("remove free reply..." + rno);
        return mapper.delete(rno) == 1;
    }

    @Override
    public List<FreeReplyVO> getList(Long bno) {
        log.info("get free replies for bno..." + bno);
        return mapper.getList(bno);
    }
}