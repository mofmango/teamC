<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 작성한 레시피</title>
</head>
<body>
    <h1>내가 작성한 레시피</h1>
    <hr>
    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>번호</th>
                <th>이미지</th>
                <th>제목</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="recipe">
                <tr>
                    <td><c:out value="${recipe.bno}"/></td>
                    <td>
                        <c:if test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진" width="100">
                        </c:if>
                    </td>
                    <td>
                        <a href="/recipe/get?bno=${recipe.bno}">
                            <c:out value="${recipe.title}"/>
                        </a>
                    </td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <br>

    <a href="/recipe/register">
        <button>새 레시피 등록</button>
    </a>
    <button onclick="history.back()">마이페이지로</button>

</body>
</html>