<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 목록</title>
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

    <h1>레시피 목록</h1>
    
    <div>
        <a href="/recipe/list"><button>전체 목록 보기</button></a>
    </div>
    <div style="margin-top: 10px;">
        <strong>정렬:</strong>
        <a href="/recipe/list?sort=newest&keyword=${cri.keyword}&category=${cri.category}&tag=${cri.tag}">최신순</a> |
        <a href="/recipe/list?sort=likes&keyword=${cri.keyword}&category=${cri.category}&tag=${cri.tag}">인기순(좋아요순)</a>
    </div>

    <form action="/recipe/list" method="get" style="margin-top: 10px;">
        <select name="type">
            <option value="T" ${cri.type == 'T' ? 'selected' : ''}>제목</option>
            <option value="G" ${cri.type == 'G' ? 'selected' : ''}>태그</option>
            <option value="W" ${cri.type == 'W' ? 'selected' : ''}>작성자</option>
        </select>
        <input type="text" name="keyword" placeholder="검색어" value="${cri.keyword}">
        <button type="submit">검색</button>
    </form>
    <br>

    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>번호</th>
                <th>이미지</th>
                <th>제목</th>
                <th>작성자</th>
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
                    <td><c:out value="${recipe.writerName}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>


</body>
</html>