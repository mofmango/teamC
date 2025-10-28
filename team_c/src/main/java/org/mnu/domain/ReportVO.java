package org.mnu.domain;

import java.util.Date;
import lombok.Data;

@Data
public class ReportVO {
    private Long report_id;
    private Long bno;
    private String reporter_id;
    private String reported_id;
    private String report_content;
    private Date report_date;
    private String status;
}