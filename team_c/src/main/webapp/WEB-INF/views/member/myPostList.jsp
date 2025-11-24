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
                        <%-- 상세 페이지로 갈 때, 현재 페이지 정보 + 어디서 왔는지(from=myposts) 같이 넘김 --%>
                        <c:url var="readUrl" value="/recipe/get">
                            <c:param name="bno" value="${recipe.bno}" />
                            <c:param name="pageNum" value="${cri.pageNum}" />
                            <c:param name="amount" value="${cri.amount}" />
                            <c:param name="from" value="myposts" />
                            <c:param name="userid" value="${userid}" />
                        </c:url>
                        <a href="${readUrl}">
                            <c:out value="${recipe.title}"/>
                        </a>
                    </td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <%-- 페이징 영역 --%>
    <c:if test="${not empty pageMaker}">
        <div style="margin-top: 20px; text-align: center;">

            <%-- 이전 블럭 --%>
            <c:if test="${pageMaker.prev}">
                <c:url var="prevUrl" value="/member/myposts">
                    <c:param name="pageNum" value="${pageMaker.startPage - 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="userid" value="${userid}" />
                </c:url>
                <a href="${prevUrl}">이전</a>
            </c:if>

            <%-- 페이지 번호들 --%>
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:choose>
                    <c:when test="${cri.pageNum == num}">
                        <strong>[${num}]</strong>
                    </c:when>
                    <c:otherwise>
                        <c:url var="pageUrl" value="/member/myposts">
                            <c:param name="pageNum" value="${num}" />
                            <c:param name="amount" value="${cri.amount}" />
                            <c:param name="userid" value="${userid}" />
                        </c:url>
                        <a href="${pageUrl}">[${num}]</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <%-- 다음 블럭 --%>
            <c:if test="${pageMaker.next}">
                <c:url var="nextUrl" value="/member/myposts">
                    <c:param name="pageNum" value="${pageMaker.endPage + 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="userid" value="${userid}" />
                </c:url>
                <a href="${nextUrl}">다음</a>
            </c:if>

        </div>
    </c:if>

    <br>

    <a href="/recipe/register">
        <button>새 레시피 등록</button>
    </a>
    <button onclick="location.href='/member/mypage'">마이페이지로</button>

</body>
</html>