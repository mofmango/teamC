<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 1080px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    .tc-table { width: 100%; border-collapse: collapse; margin-top: 20px; color: #e8eaf0; }
    .tc-table th { padding: 12px; border-bottom: 1px solid #2b2f37; color: #9ca3af; text-align: center; }
    .tc-table td { padding: 16px 12px; border-bottom: 1px solid #2b2f37; text-align: center; vertical-align: middle; }
    .tc-link { color: #e8eaf0; text-decoration: none; font-weight: 600; }
    .tc-link:hover { color: #3b82f6; }
    .tc-pagination { display: flex; justify-content: center; gap: 6px; margin-top: 30px; }
    .tc-page-btn { width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border-radius: 6px; background: #252830; color: #9ca3af; text-decoration: none; }
    .tc-page-btn.active { background: #3b82f6; color: white; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="북마크한 레시피"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 style="font-size:26px; color:white;">북마크한 레시피</h1>
        <p style="color:#9ca3af;">내가 저장한 레시피 목록입니다.</p>
    </div>

    <table class="tc-table">
        <thead>
            <tr>
                <th style="width:60px;">번호</th>
                <th style="width:100px;">이미지</th>
                <th>제목</th>
                <th style="width:120px;">작성자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="recipe">
                <tr>
                    <td><c:out value="${recipe.bno}"/></td>
                    <td>
                        <c:if test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진" width="80" height="60" style="border-radius:6px; object-fit:cover;">
                        </c:if>
                    </td>
                    <td style="text-align:left; padding-left:20px;">
                        <c:url var="readUrl" value="/recipe/get">
                            <c:param name="bno" value="${recipe.bno}" />
                            <c:param name="pageNum" value="${cri.pageNum}" />
                            <c:param name="amount" value="${cri.amount}" />
                            <c:param name="from" value="mybookmarks" />
                            <c:param name="userid" value="${userid}" />
                        </c:url>
                        <a href="${readUrl}" class="tc-link"><c:out value="${recipe.title}"/></a>
                    </td>
                    <td><c:out value="${recipe.writerName}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <c:if test="${not empty pageMaker}">
        <div class="tc-pagination">
            <c:if test="${pageMaker.prev}">
                <c:url var="prevUrl" value="/member/mybookmarks">
                    <c:param name="pageNum" value="${pageMaker.startPage - 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="userid" value="${userid}" />
                </c:url>
                <a href="${prevUrl}" class="tc-page-btn">Prev</a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:url var="pageUrl" value="/member/mybookmarks">
                    <c:param name="pageNum" value="${num}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="userid" value="${userid}" />
                </c:url>
                <a href="${pageUrl}" class="tc-page-btn ${cri.pageNum == num ? 'active' : ''}">${num}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <c:url var="nextUrl" value="/member/mybookmarks">
                    <c:param name="pageNum" value="${pageMaker.endPage + 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="userid" value="${userid}" />
                </c:url>
                <a href="${nextUrl}" class="tc-page-btn">Next</a>
            </c:if>
        </div>
    </c:if>

    <div style="margin-top:30px; text-align:center;">
        <button style="background:transparent; border:none; color:#9ca3af; cursor:pointer;" onclick="location.href='/member/mypage'">마이페이지로</button>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>