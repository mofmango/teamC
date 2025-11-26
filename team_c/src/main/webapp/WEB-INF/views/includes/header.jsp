<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- 🎯 CSS 경로를 ${ctx}를 사용하여 명확하게 지정 --%>
<link rel="stylesheet" href="${ctx}/resources/css/main.css">
<c:if test="${not empty extraCss}">
    <link rel="stylesheet" href="${ctx}/resources/css/${extraCss}">
</c:if>

<title><c:out value="${pageTitle != null ? pageTitle : 'TEAM_C'}"/></title>
</head>

<body class="${bodyClass}" data-ctx="${ctx}">

<header class="tc-header">
    <div class="tc-header-inner">
        <a href="${ctx}/" class="tc-logo">TEAM_C</a>

        <nav class="tc-nav">
            <a href="${ctx}/recipe/list" class="tc-nav-item">레시피</a>
            <a href="${ctx}/free/list" class="tc-nav-item">자유게시판</a>
            <a href="${ctx}/member/mypage" class="tc-nav-item">마이페이지</a>
        </nav>

        <div class="tc-auth">
            <c:if test="${not empty member}">
                <span class="tc-user">
                    <c:out value="${member.username}"/>님
                </span>
                <a href="${ctx}/member/logout" class="tc-btn tc-btn-ghost">로그아웃</a>
            </c:if>

            <c:if test="${empty member}">
                <a href="${ctx}/member/login" class="tc-btn tc-btn-ghost">로그인</a>
                <a href="${ctx}/member/join" class="tc-btn tc-btn-primary">회원가입</a>
            </c:if>
        </div>
    </div>
</header>

<main class="tc-container">