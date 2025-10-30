package org.mnu.service;

import java.util.List;
import org.mnu.domain.MemberVO;


public interface FollowService {
    public boolean toggleFollow(String followerId, String followingId);
    public boolean isFollowing(String followerId, String followingId);
    
    public int getFollowerCount(String userid);
    public int getFollowingCount(String userid);
    public List<MemberVO> getFollowerList(String userid);
    public List<MemberVO> getFollowingList(String userid);
}