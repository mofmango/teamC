package org.mnu.service;

import java.util.List;
import org.mnu.domain.MemberVO;
import org.mnu.mapper.FollowMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FollowServiceImpl implements FollowService {
    private FollowMapper mapper;

    @Transactional
    @Override
    public boolean toggleFollow(String followerId, String followingId) {
        if (mapper.checkFollow(followerId, followingId) > 0) {
            mapper.removeFollow(followerId, followingId);
            return false;
        } else {
            mapper.addFollow(followerId, followingId);
            return true;
        }
    }

    @Override
    public boolean isFollowing(String followerId, String followingId) {
        return mapper.checkFollow(followerId, followingId) > 0;
    }

    @Override
    public int getFollowerCount(String userid) {
        return mapper.getFollowerCount(userid);
    }

    @Override
    public int getFollowingCount(String userid) {
        return mapper.getFollowingCount(userid);
    }

    @Override
    public List<MemberVO> getFollowerList(String userid) {
        return mapper.getFollowerList(userid);
    }

    @Override
    public List<MemberVO> getFollowingList(String userid) {
        return mapper.getFollowingList(userid);
    }
}