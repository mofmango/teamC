<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />


<link rel="stylesheet" href="${ctx}/resources/css/auth.css">

<c:set var="bodyClass" value="tc-main-page tc-auth-page"/>
<c:set var="pageTitle" value="회원가입"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-auth-section">
    <div class="tc-auth-card">

        <h1 class="tc-auth-title">회원가입</h1>
        <p class="tc-auth-sub">
            TEAM_C 레시피 플랫폼 회원가
        </p>

        <c:if test="${not empty msg}">
            <div class="tc-auth-error">
                <c:out value="${msg}"/>
            </div>
        </c:if>

        <form class="tc-auth-form" method="post" action="${ctx}/member/join">

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="userid">아이디</label>
                <input class="tc-auth-input" type="text" id="userid" name="userid"
                       placeholder="아이디를 입력하세요" required/>
            </div>

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="username">이름</label>
                <input class="tc-auth-input" type="text" id="username" name="username"
                       placeholder="이름을 입력하세요" required/>
            </div>

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="email">이메일</label>
                <input class="tc-auth-input" type="email" id="email" name="email"
                       placeholder="example@teamc.com" required/>
            </div>

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="userpw">비밀번호</label>
                <input class="tc-auth-input" type="password" id="userpw" name="userpw"
                       placeholder="비밀번호를 입력하세요" required/>
            </div>


            <button type="submit" class="tc-btn tc-btn-primary tc-auth-submit">
                회원가입
            </button>
        </form>

        <div class="tc-auth-footer">
            이미 계정이 있으신가요?
            <a href="${ctx}/member/login">로그인 하기</a>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>