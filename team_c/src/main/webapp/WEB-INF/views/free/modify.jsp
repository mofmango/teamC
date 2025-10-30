<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판 글 수정</title>
</head>
<body>
    <h1>자유 게시판 글 수정</h1>
    
    <form action="/free/modify" method="post">
        <input type="hidden" name="bno" value="${board.bno}">
    
        <div>
            <label>글번호</label>
            <input type="text" value="<c:out value='${board.bno}'/>" readonly>
        </div>
        <div>
            <label>제목</label>
            <input type="text" name="title" value="<c:out value='${board.title}'/>">
        </div>
        <div>
            <label>내용</label>
            <textarea rows="5" name="content"><c:out value='${board.content}'/></textarea>
        </div>
        <div>
            <label>작성자</label>
            <input type="text" name="writer" value="<c:out value='${board.writer}'/>" readonly>
        </div>
        
        <button type="submit">수정 완료</button>
        <button type="button" onclick="location.href='/free/list'">목록으로</button>
    </form>
</body>
</html>