package org.mnu.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.FreeReplyVO;

public interface FreeReplyMapper {

    int insert(FreeReplyVO vo);          // 등록

    FreeReplyVO read(@Param("rno") Long rno);   // 한 건 조회

    int delete(@Param("rno") Long rno);  // 삭제

    List<FreeReplyVO> getList(@Param("bno") Long bno); // 해당 글의 전체 댓글
}