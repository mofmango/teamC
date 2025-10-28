package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.ReportVO;

public interface ReportMapper {
    // 새로운 신고 생성
    public void create(ReportVO report);

    // 모든 신고 목록 조회 (관리자용)
    public List<ReportVO> getList();
}