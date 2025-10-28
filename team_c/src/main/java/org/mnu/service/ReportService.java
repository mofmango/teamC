package org.mnu.service;

import java.util.List;
import org.mnu.domain.ReportVO;

public interface ReportService {
    public void report(ReportVO report);
    public List<ReportVO> getList();
}