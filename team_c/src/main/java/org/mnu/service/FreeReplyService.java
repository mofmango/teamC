package org.mnu.service;

import java.util.List;

import org.mnu.domain.FreeReplyVO;

public interface FreeReplyService {

    int register(FreeReplyVO vo);

    FreeReplyVO get(Long rno);

    boolean remove(Long rno);

    List<FreeReplyVO> getList(Long bno);
}