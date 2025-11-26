<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Context Path 변수 미리 설정 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- 
    [문제 해결 핵심] 
    header.jsp가 extraCss 변수를 처리하지 못하는 경우를 대비해
    직접 link 태그를 사용하여 CSS를 강제로 로드합니다.
    경로는 프로젝트 구조에 맞춰 수정하세요 (예: /resources/css/auth.css)
--%>
<link rel="stylesheet" href="${ctx}/resources/css/auth.css">

<c:set var="bodyClass" value="tc-main-page tc-auth-page"/>
<c:set var="pageTitle" value="로그인"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-auth-section">
    <div class="tc-auth-card">

        <h1 class="tc-auth-title">로그인</h1>
        <p class="tc-auth-sub">TEAM_C 레시피 플랫폼에 접속해 보세요.</p>

        <c:if test="${not empty msg}">
            <div class="tc-auth-error">
                <c:out value="${msg}"/>
            </div>
        </c:if>

        <form class="tc-auth-form" method="post" action="${ctx}/member/login">

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="userid">아이디</label>
                <input class="tc-auth-input" type="text" id="userid" name="userid"
                       placeholder="아이디를 입력하세요" required/>
            </div>

            <div class="tc-auth-field">
                <label class="tc-auth-label" for="userpw">비밀번호</label>
                <input class="tc-auth-input" type="password" id="userpw" name="userpw"
                       placeholder="비밀번호를 입력하세요" required/>
            </div>

            <button type="submit" class="tc-btn tc-btn-primary tc-auth-submit">
                로그인
            </button>
        </form>

        <div class="tc-auth-footer">
            아직 계정이 없으신가요?
            <a href="${ctx}/member/join">회원가입 하기</a>
        </div>

    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>