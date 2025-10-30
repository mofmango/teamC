package org.mnu.mapper;

import org.apache.ibatis.annotations.Param;

public interface BookmarkMapper {
    public void addBookmark(@Param("bno") Long bno, @Param("userid") String userid);
    
    public void removeBookmark(@Param("bno") Long bno, @Param("userid") String userid);
    
    public int checkBookmark(@Param("bno") Long bno, @Param("userid") String userid);
    
    public void deleteByBno(Long bno);
}