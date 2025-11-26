<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 스타일 정의 --%>
<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; color: #e8eaf0 !important; }
    .tc-page-section { width: 100%; max-width: 1080px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    /* 상단 로그인/회원가입 영역 */
    .tc-top-bar { display: flex; justify-content: flex-end; align-items: center; gap: 10px; margin-bottom: 20px; font-size: 14px; color: #9ca3af; }
    
    /* 테이블 스타일 */
    .tc-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .tc-table th { padding: 14px; border-bottom: 1px solid #2b2f37; color: #9ca3af; font-weight: 600; text-align: center; background: #1b1d22; }
    .tc-table td { padding: 16px 14px; border-bottom: 1px solid #2b2f37; color: #e8eaf0; text-align: center; vertical-align: middle; }
    .tc-link { color: #e8eaf0; text-decoration: none; font-weight: 600; transition: 0.2s; }
    .tc-link:hover { color: #3b82f6; }

    /* 버튼 스타일 */
    .tc-btn { padding: 8px 16px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; font-size: 13px; }
    .tc-btn-primary { background: #3b82f6; color: white; }
    .tc-btn-outline { background: transparent; border: 1px solid #2b2f37; color: #e8eaf0; }
    .tc-btn:hover { opacity: 0.9; transform: translateY(-1px); }

    /* 페이징 */
    .tc-pagination { display: flex; justify-content: center; gap: 6px; margin-top: 30px; }
    .tc-page-btn { width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border-radius: 6px; background: #252830; color: #9ca3af; text-decoration: none; font-size: 13px; }
    .tc-page-btn.active { background: #3b82f6; color: white; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="자유 게시판"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    
    <div class="tc-top-bar">
        <c:if test="${not empty member}">
            <span><strong><c:out value="${member.username}"/></strong>님 환영합니다.</span>
            <a href="/member/mypage" class="tc-btn tc-btn-outline">마이페이지</a>
            <a href="/member/logout" class="tc-btn tc-btn-outline">로그아웃</a>
        </c:if>
    </div>

    <div class="tc-page-head">
        <h1 class="tc-page-title">자유 게시판</h1>
        <p class="tc-page-sub">자유롭게 이야기를 나누는 공간입니다.</p>
    </div>

    <table class="tc-table">
        <thead>
            <tr>
                <th style="width: 80px;">번호</th>
                <th>제목</th>
                <th style="width: 120px;">작성자</th>
                <th style="width: 120px;">작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="board">
                <tr>
                    <td><c:out value="${board.bno}"/></td>
                    <td style="text-align: left; padding-left: 20px;">
                        <a href="/free/get?bno=${board.bno}" class="tc-link">
                            <c:out value="${board.title}"/>
                        </a>
                    </td>
                    <td><c:out value="${board.writer}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div style="margin-top: 20px; text-align: right;">
        <c:if test="${not empty member}">
            <a href="/free/register" class="tc-btn tc-btn-primary">새 글 등록</a>
        </c:if>
    </div>

    <c:if test="${not empty pageMaker}">
        <div class="tc-pagination">
            <c:if test="${pageMaker.prev}">
                <a href="/free/list?pageNum=${pageMaker.startPage - 1}&amount=${cri.amount}" class="tc-page-btn">Prev</a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <a href="/free/list?pageNum=${num}&amount=${cri.amount}" class="tc-page-btn ${cri.pageNum == num ? 'active' : ''}">
                    ${num}
                </a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <a href="/free/list?pageNum=${pageMaker.endPage + 1}&amount=${cri.amount}" class="tc-page-btn">Next</a>
            </c:if>
        </div>
    </c:if>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>