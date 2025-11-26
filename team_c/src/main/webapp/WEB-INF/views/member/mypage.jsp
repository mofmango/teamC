<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 800px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-profile-card { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 40px; text-align: center; margin-bottom: 24px; }
    .tc-username { font-size: 28px; font-weight: 800; color: white; margin-bottom: 20px; }
    
    .tc-stats-row { display: flex; justify-content: center; gap: 40px; margin-bottom: 20px; }
    .tc-stat-box { text-align: center; }
    .tc-stat-link { text-decoration: none; color: #e8eaf0; transition: 0.2s; }
    .tc-stat-link:hover { color: #3b82f6; }
    .tc-stat-num { font-size: 24px; font-weight: 700; display: block; margin-top: 4px; }
    .tc-stat-label { font-size: 14px; color: #9ca3af; }
    
    .tc-menu-list { display: flex; flex-direction: column; gap: 10px; }
    .tc-menu-item { background: #252830; padding: 16px; border-radius: 12px; text-decoration: none; color: #e8eaf0; font-weight: 600; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; }
    .tc-menu-item:hover { background: #3b82f6; color: white; }
    .tc-menu-count { background: rgba(255,255,255,0.1); padding: 2px 8px; border-radius: 99px; font-size: 12px; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="마이페이지"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    
    <div class="tc-profile-card">
        <div class="tc-username"><c:out value="${member.username}"/>님</div>
        
        <div class="tc-stats-row">
            <div class="tc-stat-box">
                <a href="/member/myposts?userid=${member.userid}" class="tc-stat-link">
                    <span class="tc-stat-label">게시물</span>
                    <span class="tc-stat-num">${postCount}</span>
                </a>
            </div>
            <div class="tc-stat-box">
                <a href="/member/followers?userid=${member.userid}" class="tc-stat-link">
                    <span class="tc-stat-label">팔로워</span>
                    <span class="tc-stat-num">${followerCount}</span>
                </a>
            </div>
            <div class="tc-stat-box">
                <a href="/member/following?userid=${member.userid}" class="tc-stat-link">
                    <span class="tc-stat-label">팔로잉</span>
                    <span class="tc-stat-num">${followingCount}</span>
                </a>
            </div>
        </div>
    </div>

    <div class="tc-menu-list">
        <a href="/member/mybookmarks?userid=${member.userid}" class="tc-menu-item">
            <span>📑 북마크한 레시피</span>
            <span class="tc-menu-count">${bookmarkCount}</span>
        </a>
        <a href="/member/mylikes?userid=${member.userid}" class="tc-menu-item">
            <span>❤️ 좋아요 누른 레시피</span>
            <span class="tc-menu-count">${likeCount}</span>
        </a>
        <a href="/member/myfridge" class="tc-menu-item">
            <span>🥦 나의 냉장고 관리</span>
            <span>&rsaquo;</span>
        </a>
        
        <c:if test="${member.role == 'ROLE_ADMIN'}">
            <a href="/admin/main" class="tc-menu-item" style="background: #7f1d1d; color: #fca5a5;">
                <span>⚙️ 관리자 페이지</span>
                <span>&rsaquo;</span>
            </a>
        </c:if>
    </div>

    <div style="margin-top: 30px; text-align: center;">
        <button style="background: transparent; border: 1px solid #2b2f37; color: #9ca3af; padding: 10px 20px; border-radius: 8px; cursor: pointer;" onclick="location.href='/recipe/list'">전체 목록으로</button>
    </div>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>