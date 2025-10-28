<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageOwner.username}님의 페이지</title>
</head>
<body>

    <h1><c:out value="${pageOwner.username}"/>님의 페이지</h1>
    <hr>

    <div>
        <a href="/member/followers?userid=${pageOwner.userid}">팔로워 ${followerCount}</a>
        &nbsp;&nbsp;&nbsp;
        <a href="/member/following?userid=${pageOwner.userid}">팔로잉 ${followingCount}</a>
    </div>

    <%-- 로그인했고, 내 페이지가 아닐 경우에만 팔로우 버튼 표시 --%>
    <c:if test="${not empty member and member.userid != pageOwner.userid}">
        <button id="followBtn" data-writer="${pageOwner.userid}">
            <c:choose>
                <c:when test="${isFollowing}">팔로잉</c:when>
                <c:otherwise>팔로우</c:otherwise>
            </c:choose>
        </button>
    </c:if>
    <hr>

    <h3><c:out value="${pageOwner.username}"/>님이 작성한 레시피</h3>
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
            <c:forEach items="${myList}" var="recipe">
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
    <button onclick="location.href='/recipe/list'">전체 목록으로</button>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $('#followBtn').on('click', function() {
        var followingId = $(this).data('writer');

        $.ajax({
            type: 'post',
            url: '/follow/' + followingId,
            success: function(result) {
                if(result.isFollowing) {
                    $('#followBtn').text('팔로잉');
                } else {
                    $('#followBtn').text('팔로우');
                }
                // 실시간으로 숫자도 변경해주면 좋음 (추후 개선)
            },
            error: function(xhr) {
                if(xhr.status == 401) {
                    alert("로그인이 필요합니다.");
                }
            }
        });
    });
});
</script>
</body>
</html>