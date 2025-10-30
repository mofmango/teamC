<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판 글 등록</title>
</head>
<body>
    <h1>자유 게시판 글 등록</h1>
    
    <form action="/free/register" method="post">
        <div>
            <label>제목</label>
            <input type="text" name="title">
        </div>
        <div>
            <label>내용</label>
            <textarea rows="5" name="content"></textarea>
        </div>
        
        <button type="submit">등록</button>
        <button type="button" onclick="location.href='/free/list'">목록으로</button>
    </form>
</body>
</html>