<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 800px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    /* 메뉴 리스트 스타일 (마이페이지와 동일) */
    .tc-menu-list { display: flex; flex-direction: column; gap: 10px; margin-top: 20px; }
    .tc-menu-item { 
        background: #1b1d22; 
        border: 1px solid #2b2f37; 
        padding: 20px; 
        border-radius: 12px; 
        text-decoration: none; 
        color: #e8eaf0; 
        font-weight: 600; 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        transition: 0.2s; 
    }
    .tc-menu-item:hover { 
        background: #3b82f6; 
        color: white; 
        border-color: #3b82f6; 
    }
    
    .tc-btn-ghost { 
        background: transparent; 
        color: #9ca3af; 
        border: 1px solid #2b2f37; 
        padding: 10px 20px; 
        border-radius: 8px; 
        cursor: pointer; 
        font-size: 14px; 
        font-weight: 600; 
    }
    .tc-btn-ghost:hover { background: #252830; color: white; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="관리자 페이지"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title" style="color: white; font-size: 28px; margin-bottom: 8px;">관리자 페이지</h1>
        <p class="tc-page-sub" style="color: #9ca3af;">회원 및 신고 내역을 관리하는 페이지입니다.</p>
    </div>

    <div class="tc-menu-list">
        <a href="/admin/memberList" class="tc-menu-item">
            <span>👥 회원 목록 관리</span>
            <span>&rsaquo;</span>
        </a>
        <a href="/admin/reportList" class="tc-menu-item">
            <span>🚨 신고 내역 관리</span>
            <span>&rsaquo;</span>
        </a>
    </div>
    
    <div style="margin-top: 30px; text-align: center;">
        <button class="tc-btn-ghost" onclick="location.href='/member/mypage'">마이페이지로 돌아가기</button>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>