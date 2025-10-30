package org.mnu.service;

import java.util.List;

import org.mnu.domain.MemberVO;
import org.mnu.mapper.MemberMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {
    
    private MemberMapper mapper;
    
    @Override
    public void join(MemberVO member) {
        log.info("join......" + member);
        mapper.join(member);
    }
    
    @Override
    public MemberVO login(MemberVO member) {
        log.info("login......" + member);
        return mapper.login(member);
    }
    
    @Override
    public MemberVO get(String userid) {
        log.info("get user......" + userid);
        return mapper.get(userid);
    }
    
    @Override
    public List<MemberVO> getList() {
        log.info("get member list......");
        return mapper.getList();
    }
}