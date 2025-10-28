package org.mnu.service;

import org.mnu.mapper.BookmarkMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class BookmarkServiceImpl implements BookmarkService {
    
    private BookmarkMapper mapper;
    
    @Transactional
    @Override
    public boolean toggleBookmark(Long bno, String userid) {
        if (mapper.checkBookmark(bno, userid) > 0) {
            mapper.removeBookmark(bno, userid);
            return false; // 북마크 취소됨
        } else {
            mapper.addBookmark(bno, userid);
            return true; // 북마크 추가됨
        }
    }
}