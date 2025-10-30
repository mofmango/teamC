package org.mnu.service;

import java.util.List;
import org.mnu.domain.ReportVO;
import org.mnu.mapper.ReportMapper;
import org.springframework.stereotype.Service;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ReportServiceImpl implements ReportService {

    private ReportMapper mapper;

    @Override
    public void report(ReportVO report) {
        mapper.create(report);
    }

    @Override
    public List<ReportVO> getList() {
        return mapper.getList();
    }
}