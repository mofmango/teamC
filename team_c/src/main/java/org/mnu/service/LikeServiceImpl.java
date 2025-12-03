package org.mnu.service;

import org.mnu.mapper.LikeMapper;
import org.mnu.mapper.RecipeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class LikeServiceImpl implements LikeService {

    private LikeMapper likeMapper;
    private RecipeMapper recipeMapper;

    @Transactional
    @Override
    public void toggleLike(Long bno, String userid) {
        // 사용자가 이미 좋아요를 눌렀는지 확인
        if (likeMapper.checkLike(bno, userid) > 0) {
            // 이미 눌렀으면 좋아요 취소
            likeMapper.removeLike(bno, userid);
            recipeMapper.updateLikeCount(bno, -1);
        } else {
            // 누르지 않았으면 좋아요 추가
            likeMapper.addLike(bno, userid);
            recipeMapper.updateLikeCount(bno, 1);
        }
    }

    @Override
    public int getLikeCount(Long bno) {
        return recipeMapper.read(bno).getLike_count();
    }

    @Override
    public boolean hasUserLiked(Long bno, String userid) {
        return likeMapper.checkLike(bno, userid) > 0;
    }
}