<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 1080px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-table { width: 100%; border-collapse: collapse; margin-top: 20px; color: #e8eaf0; }
    .tc-table th { padding: 14px; border-bottom: 1px solid #2b2f37; color: #9ca3af; font-weight: 600; text-align: center; background: #1b1d22; }
    .tc-table td { padding: 16px 14px; border-bottom: 1px solid #2b2f37; text-align: center; vertical-align: middle; font-size: 14px; }
    
    .tc-btn-group { display: flex; justify-content: center; gap: 10px; margin-top: 30px; }
    .tc-btn { padding: 8px 16px; border-radius: 8px; border: 1px solid #2b2f37; background: transparent; color: #9ca3af; cursor: pointer; font-weight: 600; transition: 0.2s; }
    .tc-btn:hover { background: #252830; color: white; }
    .tc-btn-primary { background: #3b82f6; color: white; border: none; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="전체 회원 목록"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title" style="color:white; font-size:26px;">전체 회원 목록</h1>
        <p class="tc-page-sub" style="color:#9ca3af;">가입된 모든 회원을 조회합니다.</p>
    </div>

    <table class="tc-table">
        <thead>
            <tr>
                <th>아이디</th>
                <th>이름</th>
                <th>이메일</th>
                <th>가입일</th>
                <th>권한</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="member">
                <tr>
                    <td><c:out value="${member.userid}"/></td>
                    <td><c:out value="${member.username}"/></td>
                    <td><c:out value="${member.email}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${member.regdate}"/></td>
                    <td>
                        <span style="background: #252830; padding: 4px 8px; border-radius: 6px; font-size: 12px;">
                            <c:out value="${member.role}"/>
                        </span>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="tc-btn-group">
        <button class="tc-btn tc-btn-primary" onclick="location.href='/admin/main'">관리자 홈</button>
        <button class="tc-btn" onclick="location.href='/member/mypage'">마이페이지</button>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>