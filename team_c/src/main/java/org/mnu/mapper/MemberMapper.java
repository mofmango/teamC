package org.mnu.mapper;

import java.util.List;

import org.mnu.domain.MemberVO;

public interface MemberMapper {
    // 회원가입
    public void join(MemberVO member);
    
    // 로그인 또는 회원 정보 조회
    public MemberVO read(String userid);
    
    public MemberVO login(MemberVO member);
    
    public MemberVO get(String userid);
    
    public List<MemberVO> getList();
}