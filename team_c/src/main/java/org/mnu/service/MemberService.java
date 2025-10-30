package org.mnu.service;

import java.util.List;

import org.mnu.domain.MemberVO;

public interface MemberService {
    public void join(MemberVO member);
    public MemberVO login(MemberVO member);
    public MemberVO get(String userid);
    public List<MemberVO> getList();
}