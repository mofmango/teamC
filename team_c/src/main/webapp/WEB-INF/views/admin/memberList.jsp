<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 회원 목록</title>
</head>
<body>

    <h1>전체 회원 목록</h1>

    <table border="1" style="width: 100%; text-align: center;">
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
                    <td><c:out value="${member.role}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <br>
    <button onclick="location.href='/admin/main'">관리자 홈으로</button>
    <button onclick="location.href='/member/mypage'">마이페이지로</button>
</body>
</html>