<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${title}</title>
</head>
<body>
    <h1>${title}</h1>
    <hr>
    <ul>
	    <c:forEach items="${userList}" var="user">
	        <li>
	            <a href="/member/userpage?userid=${user.userid}">
	                <strong><c:out value="${user.username}"/></strong> (<c:out value="${user.userid}"/>)
	            </a>
	        </li>
	    </c:forEach>
	</ul>
    <br>
    <button onclick="history.back()">뒤로가기</button>
</body>
</html>