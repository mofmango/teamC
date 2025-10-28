package org.mnu.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.mnu.domain.MemberVO;

public interface FollowMapper {
    public void addFollow(@Param("followerId") String followerId, @Param("followingId") String followingId);
    public void removeFollow(@Param("followerId") String followerId, @Param("followingId") String followingId);
    public int checkFollow(@Param("followerId") String followerId, @Param("followingId") String followingId);

    public int getFollowerCount(String userid);
    public int getFollowingCount(String userid);
    public List<MemberVO> getFollowerList(String userid);
    public List<MemberVO> getFollowingList(String userid);
}