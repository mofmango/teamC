<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 800px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-form-card { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 32px; }
    .tc-form-row { margin-bottom: 20px; }
    .tc-label { display: block; margin-bottom: 8px; color: #9ca3af; font-size: 14px; font-weight: 600; }
    .tc-input, .tc-textarea { width: 100%; background: #252830; border: 1px solid #2b2f37; border-radius: 8px; padding: 12px; color: #e8eaf0; font-size: 14px; box-sizing: border-box; }
    .tc-input[readonly] { background: #141518; color: #71717a; }
    .tc-input:focus, .tc-textarea:focus { outline: none; border-color: #3b82f6; }
    
    .tc-btn { padding: 10px 20px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; font-size: 14px; }
    .tc-btn-primary { background: #3b82f6; color: white; }
    .tc-btn-outline { background: transparent; border: 1px solid #2b2f37; color: #9ca3af; }
    .tc-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="글 수정"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title">글 수정</h1>
    </div>

    <div class="tc-form-card">
        <form action="/free/modify" method="post">
            <input type="hidden" name="bno" value="${board.bno}">
        
            <div class="tc-form-row">
                <label class="tc-label">글번호</label>
                <input type="text" value="<c:out value='${board.bno}'/>" class="tc-input" readonly>
            </div>
            
            <div class="tc-form-row">
                <label class="tc-label">작성자</label>
                <input type="text" name="writer" value="<c:out value='${board.writer}'/>" class="tc-input" readonly>
            </div>

            <div class="tc-form-row">
                <label class="tc-label">제목</label>
                <input type="text" name="title" value="<c:out value='${board.title}'/>" class="tc-input" required>
            </div>
            
            <div class="tc-form-row">
                <label class="tc-label">내용</label>
                <textarea name="content" rows="10" class="tc-textarea" required><c:out value='${board.content}'/></textarea>
            </div>
            
            <div class="tc-actions">
                <button type="button" class="tc-btn tc-btn-outline" onclick="location.href='/free/list'">취소</button>
                <button type="submit" class="tc-btn tc-btn-primary">수정 완료</button>
            </div>
        </form>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>