package org.mnu.mapper;

import org.apache.ibatis.annotations.Param;

public interface LikeMapper {
    // 좋아요 추가
    public void addLike(@Param("bno") Long bno, @Param("userid") String userid);
    // 좋아요 취소
    public void removeLike(@Param("bno") Long bno, @Param("userid") String userid);
    // 좋아요 여부 확인
    public int checkLike(@Param("bno") Long bno, @Param("userid") String userid);
	
	void deleteByBno(Long bno);
}