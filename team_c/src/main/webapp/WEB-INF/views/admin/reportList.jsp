<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 신고 목록</title>
</head>
<body>

    <h1>전체 신고 목록</h1>

    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>신고 번호</th>
                <th>신고된 글</th>
                <th>신고 사유</th>
                <th>신고자</th>
                <th>피신고자</th>
                <th>신고일</th>
                <th>상태</th>
                <th>조치</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="report">
                <tr>
                    <td><c:out value="${report.report_id}"/></td>
                    <td><a href="/recipe/get?bno=${report.bno}" target="_blank">${report.bno}번 글 보기</a></td>
                    <td><c:out value="${report.report_content}"/></td>
                    <td><c:out value="${report.reporter_id}"/></td>
                    <td><c:out value="${report.reported_id}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${report.report_date}"/></td>
                    <td><c:out value="${report.status}"/></td>
                    <td>
                        <form action="/recipe/remove" method="post" onsubmit="return confirm('정말로 이 게시글을 삭제하시겠습니까?');">
                            <input type="hidden" name="bno" value="${report.bno}">
                            <button type="submit">게시글 삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <br>
    <button onclick="location.href='/admin/main'">관리자 홈으로</button>
</body>
</html>