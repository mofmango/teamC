<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* 1. Body 설정 */
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    
    /* 2. 레이아웃 (신고 폼은 집중도를 위해 폭을 좁게 설정) */
    .tc-page-section { width: 100%; max-width: 600px; margin: 60px auto; padding: 0 20px; box-sizing: border-box; }
    
    /* 3. 카드 스타일 */
    .tc-report-card { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 40px; }
    
    /* 폼 요소 스타일 */
    .tc-label { display: block; margin-bottom: 10px; color: #9ca3af; font-size: 14px; font-weight: 600; }
    .tc-textarea { width: 100%; background: #252830; border: 1px solid #2b2f37; border-radius: 8px; padding: 14px; color: #e8eaf0; font-size: 14px; resize: vertical; outline: none; box-sizing: border-box; }
    .tc-textarea:focus { border-color: #ef4444; } /* 신고는 빨간색 포커스 */
    
    /* 게시글 정보 박스 */
    .tc-info-box { background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); color: #fca5a5; padding: 16px; border-radius: 8px; margin-bottom: 24px; font-size: 14px; line-height: 1.5; }
    .tc-info-highlight { color: white; font-weight: 700; }

    /* 버튼 */
    .tc-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
    .tc-btn { padding: 10px 20px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; font-size: 14px; transition: 0.2s; }
    .tc-btn-outline { background: transparent; border: 1px solid #2b2f37; color: #9ca3af; }
    .tc-btn-outline:hover { background: #252830; color: white; }
    .tc-btn-danger { background: #ef4444; color: white; }
    .tc-btn-danger:hover { background: #dc2626; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="게시글 신고"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    
    <div class="tc-page-head" style="text-align: center; margin-bottom: 40px;">
        <h1 class="tc-page-title" style="color:white; font-size:28px; margin-bottom:8px;">🚨 게시글 신고</h1>
        <p class="tc-page-sub" style="color:#9ca3af;">부적절한 게시글을 발견하셨나요? 신고 사유를 알려주세요.</p>
    </div>

    <div class="tc-report-card">
        
        <div class="tc-info-box">
            <span class="tc-info-highlight">No. ${param.bno}</span> 게시글을 신고합니다.<br>
            허위 신고 시 불이익을 받을 수 있으니 신중하게 작성해 주세요.
        </div>

        <form action="/report/register" method="post">
            <input type="hidden" name="bno" value="${param.bno}">
            <input type="hidden" name="reported_id" value="${param.reported_id}">

            <div style="margin-bottom: 20px;">
                <label class="tc-label">신고 사유</label>
                <textarea name="report_content" rows="6" class="tc-textarea" placeholder="구체적인 신고 사유를 입력해주세요. (예: 욕설/비방, 광고성 게시글, 도배 등)" required></textarea>
            </div>

            <div class="tc-actions">
                <button type="button" class="tc-btn tc-btn-outline" onclick="history.back()">취소</button>
                <button type="submit" class="tc-btn tc-btn-danger">신고하기</button>
            </div>
        </form>
    </div>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>