<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 신고</title>
</head>
<body>
    <h1>게시글 신고</h1>
    <p><strong>${param.bno}</strong>번 게시글을 신고합니다.</p>

    <form action="/report/register" method="post">
        <input type="hidden" name="bno" value="${param.bno}">
        <input type="hidden" name="reported_id" value="${param.reported_id}">

        <div>
            <label>신고 사유</label><br>
            <textarea name="report_content" rows="5" cols="50" placeholder="신고 사유를 입력해주세요."></textarea>
        </div>

        <button type="submit">신고하기</button>
        <button type="button" onclick="history.back()">취소</button>
    </form>
</body>
</html>