package org.mnu.service;

public interface LikeService {
    public void toggleLike(Long bno, String userid);
    public int getLikeCount(Long bno);
    public boolean hasUserLiked(Long bno, String userid);
}