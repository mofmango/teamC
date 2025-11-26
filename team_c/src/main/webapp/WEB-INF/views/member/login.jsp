<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 다크 테마 + auth.css 적용 --%>
<c:set var="extraCss" value="auth.css"/>
<c:set var="bodyClass" value="tc-main-page tc-auth-page"/>
<c:set var="pageTitle" value="로그인"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="tc-auth-card">

    <h1 class="tc-auth-title">로그인</h1>
    <p class="tc-auth-sub">TEAM_C 레시피 플랫폼에 접속해 보세요.</p>

    <%-- 에러 메시지 (필요시 msg 또는 error 등 프로젝트에 맞게 사용) --%>
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

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>