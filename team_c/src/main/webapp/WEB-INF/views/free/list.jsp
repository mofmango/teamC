<%@ page language="java" contentType="text-html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
</head>
<body>

    <div>
        <c:if test="${not empty member}">
            <p><c:out value="${member.username}"/>님 환영합니다.</p>
            <a href="/member/mypage"><button>마이페이지</button></a>
            <a href="/member/logout"><button>로그아웃</button></a>
        </c:if>
        <c:if test="${empty member}">
            <a href="/member/login"><button>로그인</button></a>
            <a href="/member/join"><button>회원가입</button></a>
        </c:if>
    </div>
    <hr>

    <h1>자유 게시판</h1>

    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="board">
                <tr>
                    <td><c:out value="${board.bno}"/></td>
                    <td>
                        <a href="/free/get?bno=${board.bno}">
                            <c:out value="${board.title}"/>
                        </a>
                    </td>
                    <td><c:out value="${board.writer}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <c:if test="${not empty member}">
        <a href="/free/register">
            <button>새 글 등록</button>
        </a>
    </c:if>

</body>
</html>