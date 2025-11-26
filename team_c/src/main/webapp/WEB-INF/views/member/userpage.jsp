<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 스타일 정의 --%>
<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; color: #e8eaf0 !important; }
    .tc-page-section { width: 100%; max-width: 1080px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    /* 테이블 스타일 */
    .tc-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .tc-table th { padding: 12px; border-bottom: 1px solid #2b2f37; color: #9ca3af; font-weight: 600; }
    .tc-table td { padding: 16px 12px; border-bottom: 1px solid #2b2f37; color: #e8eaf0; vertical-align: middle; text-align: center; }
    .tc-table img { border-radius: 8px; object-fit: cover; }
    .tc-link { color: #e8eaf0; text-decoration: none; font-weight: 600; transition: 0.2s; }
    .tc-link:hover { color: #3b82f6; }

    /* 버튼 스타일 */
    .tc-btn { padding: 8px 16px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; transition: 0.2s; display: inline-block; text-decoration: none; font-size: 14px; }
    .tc-btn-primary { background: #3b82f6; color: white; }
    .tc-btn-outline { background: transparent; border: 1px solid #2b2f37; color: #e8eaf0; }
    .tc-btn-ghost { background: transparent; color: #9ca3af; }
    .tc-btn:hover { opacity: 0.9; transform: translateY(-1px); }

    /* 프로필 박스 */
    .tc-profile-box { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 30px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
    .tc-stats { display: flex; gap: 20px; }
    .tc-stat-item a { color: #9ca3af; text-decoration: none; font-size: 14px; }
    .tc-stat-item a:hover { color: #3b82f6; }

    /* 페이징 */
    .tc-pagination { display: flex; justify-content: center; gap: 6px; margin-top: 30px; }
    .tc-page-btn { width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border-radius: 6px; background: #252830; color: #9ca3af; text-decoration: none; font-size: 13px; }
    .tc-page-btn.active { background: #3b82f6; color: white; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="${pageOwner.username}님의 페이지"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    
    <div class="tc-profile-box">
        <div>
            <h1 style="margin: 0 0 10px 0; font-size: 24px; color: white;"><c:out value="${pageOwner.username}"/>님의 페이지</h1>
            <div class="tc-stats">
                <div class="tc-stat-item">
                    <a href="/member/followers?userid=${pageOwner.userid}">팔로워 <strong>${followerCount}</strong></a>
                </div>
                <div class="tc-stat-item">
                    <a href="/member/following?userid=${pageOwner.userid}">팔로잉 <strong>${followingCount}</strong></a>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty member and member.userid != pageOwner.userid}">
            <button id="followBtn" class="tc-btn tc-btn-outline" data-writer="${pageOwner.userid}">
                <c:choose>
                    <c:when test="${isFollowing}">팔로잉</c:when>
                    <c:otherwise>팔로우</c:otherwise>
                </c:choose>
            </button>
        </c:if>
    </div>

    <h3 style="font-size: 18px; color: white; margin-bottom: 15px;">작성한 레시피</h3>
    
    <table class="tc-table">
        <thead>
            <tr>
                <th style="width: 60px;">번호</th>
                <th style="width: 120px;">이미지</th>
                <th>제목</th>
                <th style="width: 120px;">작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${myList}" var="recipe">
                <tr>
                    <td><c:out value="${recipe.bno}"/></td>
                    <td>
                        <c:if test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진" width="80" height="60">
                        </c:if>
                    </td>
                    <td style="text-align: left; padding-left: 20px;">
                        <c:url var="readUrl" value="/recipe/get">
                            <c:param name="bno" value="${recipe.bno}" />
                            <c:param name="pageNum" value="${cri.pageNum}" />
                            <c:param name="amount" value="${cri.amount}" />
                        </c:url>
                        <a href="${readUrl}" class="tc-link">
                            <c:out value="${recipe.title}"/>
                        </a>
                    </td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <c:if test="${not empty pageMaker}">
        <div class="tc-pagination">
            <c:if test="${pageMaker.prev}">
                <c:url var="prevUrl" value="/member/userpage">
                    <c:param name="userid" value="${pageOwner.userid}" />
                    <c:param name="pageNum" value="${pageMaker.startPage - 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                </c:url>
                <a href="${prevUrl}" class="tc-page-btn">Prev</a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:url var="pageUrl" value="/member/userpage">
                    <c:param name="userid" value="${pageOwner.userid}" />
                    <c:param name="pageNum" value="${num}" />
                    <c:param name="amount" value="${cri.amount}" />
                </c:url>
                <a href="${pageUrl}" class="tc-page-btn ${cri.pageNum == num ? 'active' : ''}">${num}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <c:url var="nextUrl" value="/member/userpage">
                    <c:param name="userid" value="${pageOwner.userid}" />
                    <c:param name="pageNum" value="${pageMaker.endPage + 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                </c:url>
                <a href="${nextUrl}" class="tc-page-btn">Next</a>
            </c:if>
        </div>
    </c:if>

    <div style="margin-top: 30px; text-align: center;">
        <button class="tc-btn tc-btn-ghost" onclick="location.href='/recipe/list'">전체 목록으로</button>
    </div>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $('#followBtn').on('click', function() {
        var followingId = $(this).data('writer');
        $.ajax({
            type: 'post', url: '/follow/' + followingId,
            success: function(result) {
                if(result.isFollowing) $('#followBtn').text('팔로잉');
                else $('#followBtn').text('팔로우');
            },
            error: function(xhr) {
                if(xhr.status == 401) alert("로그인이 필요합니다.");
            }
        });
    });
});
</script>