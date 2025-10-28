<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판 상세 정보</title>
</head>
<body>

    <h1>자유 게시판 상세 정보</h1>
    
    <div>
        <label>글번호</label>
        <input type="text" value="<c:out value='${board.bno}'/>" readonly>
    </div>
    <div>
        <label>제목</label>
        <input type="text" value="<c:out value='${board.title}'/>" readonly>
    </div>
    <div>
        <label>내용</label>
        <textarea rows="5" readonly><c:out value='${board.content}'/></textarea>
    </div>
    <div>
        <label>작성자</label>
        <input type="text" value="<c:out value='${board.writer}'/>" readonly>
    </div>

    <c:if test="${member.userid == board.writer}">
        <button type="button" 
            onclick="location.href='/free/modify?bno=${board.bno}'">수정</button>
        <form action="/free/remove" method="post" style="display: inline;">
            <input type="hidden" name="bno" value="${board.bno}">
            <button type="submit">삭제</button>
        </form>
    </c:if>
    <button type="button" onclick="location.href='/free/list'">목록으로</button>
    
</body>
</html>