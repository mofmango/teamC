<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
    <h1>관리자 페이지</h1>
    <p>이 페이지는 관리자만 볼 수 있습니다.</p>
    <hr>
    <ul>
        <li><a href="/admin/memberList">회원 목록 관리</a></li>
        <li><a href="/admin/reportList">신고 내역 관리</a></li>
    </ul>
    
    <br>
    <button onclick="location.href='/member/mypage'">마이페이지로</button>

</body>
</html>