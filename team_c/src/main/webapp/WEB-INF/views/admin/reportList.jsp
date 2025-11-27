<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 1080px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-table { width: 100%; border-collapse: collapse; margin-top: 20px; color: #e8eaf0; }
    .tc-table th { padding: 14px; border-bottom: 1px solid #2b2f37; color: #9ca3af; font-weight: 600; text-align: center; background: #1b1d22; }
    .tc-table td { padding: 16px 14px; border-bottom: 1px solid #2b2f37; text-align: center; vertical-align: middle; font-size: 14px; }
    
    .tc-link { color: #3b82f6; text-decoration: none; font-weight: 600; }
    .tc-link:hover { text-decoration: underline; }
    
    .tc-btn-danger { background: rgba(239, 68, 68, 0.1); border: 1px solid #ef4444; color: #ef4444; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 12px; transition: 0.2s; }
    .tc-btn-danger:hover { background: #ef4444; color: white; }
    
    .tc-btn-home { margin-top: 30px; padding: 10px 20px; border-radius: 8px; background: #3b82f6; color: white; border: none; font-weight: 600; cursor: pointer; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="전체 신고 목록"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title" style="color:white; font-size:26px;">전체 신고 목록</h1>
        <p class="tc-page-sub" style="color:#9ca3af;">접수된 게시글 신고 내역을 확인하고 조치합니다.</p>
    </div>

    <table class="tc-table">
        <thead>
            <tr>
                <th style="width: 80px;">번호</th>
                <th style="width: 120px;">대상 글</th>
                <th>신고 사유</th>
                <th style="width: 100px;">신고자</th>
                <th style="width: 100px;">피신고자</th>
                <th style="width: 100px;">신고일</th>
                <th style="width: 80px;">상태</th>
                <th style="width: 100px;">조치</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="report">
                <tr>
                    <td><c:out value="${report.report_id}"/></td>
                    <td>
                        <a href="/recipe/get?bno=${report.bno}" target="_blank" class="tc-link">
                            #<c:out value="${report.bno}"/> 보기
                        </a>
                    </td>
                    <td style="text-align: left; color: #d1d5db;"><c:out value="${report.report_content}"/></td>
                    <td><c:out value="${report.reporter_id}"/></td>
                    <td><c:out value="${report.reported_id}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${report.report_date}"/></td>
                    <td>
                        <span style="color: ${report.status == '처리완료' ? '#3b82f6' : '#ef4444'}; font-weight: 600;">
                            <c:out value="${report.status}"/>
                        </span>
                    </td>
                    <td>
                        <form action="/recipe/remove" method="post" onsubmit="return confirm('정말로 이 게시글을 삭제하시겠습니까?');">
                            <input type="hidden" name="bno" value="${report.bno}">
                            <button type="submit" class="tc-btn-danger">게시글 삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <div style="text-align: center;">
        <button class="tc-btn-home" onclick="location.href='/admin/main'">관리자 홈으로</button>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>