<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 600px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-user-list { list-style: none; padding: 0; }
    .tc-user-item { background: #1b1d22; border: 1px solid #2b2f37; padding: 16px 20px; margin-bottom: 10px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; }
    .tc-user-item:hover { border-color: #3b82f6; }
    .tc-user-link { text-decoration: none; color: #e8eaf0; font-size: 16px; }
    .tc-user-id { color: #9ca3af; font-size: 14px; margin-left: 6px; }
    
    .tc-btn-back { background: transparent; color: #9ca3af; border: 1px solid #2b2f37; padding: 8px 16px; border-radius: 8px; cursor: pointer; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="${title}"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div style="margin-bottom: 20px;">
        <h1 style="color: white; font-size: 24px;">${title}</h1>
    </div>

    <ul class="tc-user-list">
        <c:forEach items="${userList}" var="user">
            <li class="tc-user-item">
                <a href="/member/userpage?userid=${user.userid}" class="tc-user-link">
                    <strong><c:out value="${user.username}"/></strong> 
                    <span class="tc-user-id">(@<c:out value="${user.userid}"/>)</span>
                </a>
                <span style="color:#3b82f6; font-size:20px;">&rsaquo;</span>
            </li>
        </c:forEach>
    </ul>
    
    <div style="margin-top: 20px; text-align: center;">
        <button class="tc-btn-back" onclick="history.back()">뒤로가기</button>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>