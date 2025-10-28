<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>

    <h1><c:out value="${member.username}"/>님의 마이페이지</h1>
    <hr>
    
    <div style="display: flex; justify-content: space-around; text-align: center;">
        <div>
            <a href="/member/myposts?userid=${member.userid}" style="text-decoration: none; color: black;">
                <h3>게시물</h3>
                <p>${postCount}</p>
            </a>
        </div>
        <div>
            <a href="/member/followers?userid=${member.userid}" style="text-decoration: none; color: black;">
                <h3>팔로워</h3>
                <p>${followerCount}</p>
            </a>
        </div>
        <div>
            <a href="/member/following?userid=${member.userid}" style="text-decoration: none; color: black;">
                <h3>팔로잉</h3>
                <p>${followingCount}</p>
            </a>
        </div>
    </div>
    <hr>
    
    <div>
        <p><a href="/member/mybookmarks?userid=${member.userid}">북마크한 글 (${bookmarkCount})</a></p>
        <p><a href="/member/mylikes?userid=${member.userid}">좋아요 누른 글 (${likeCount})</a></p>
        <p><a href="/member/myfridge">나의 냉장고 관리</a></p>
    </div>

    <br>
    
    <c:if test="${member.role == 'ROLE_ADMIN'}">
        <a href="/admin/main"><button style="background-color: lightcoral; color: white;">관리자 페이지</button></a>
    </c:if>
    
    <button onclick="location.href='/recipe/list'">전체 목록으로</button>

</body>
</html>