<%@ page language="java" contentType="text-html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
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

    <h1>자유 게시판</h1>

    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list}" var="board">
                <tr>
                    <td><c:out value="${board.bno}"/></td>
                    <td>
                        <a href="/free/get?bno=${board.bno}">
                            <c:out value="${board.title}"/>
                        </a>
                    </td>
                    <td><c:out value="${board.writer}"/></td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <c:if test="${not empty member}">
        <a href="/free/register">
            <button>새 글 등록</button>
        </a>
    </c:if>
<!-- 페이징 영역 -->
    <c:if test="${not empty pageMaker}">
        <div style="margin-top: 20px; text-align: center;">

            <c:if test="${pageMaker.prev}">
                <a href="/free/list?pageNum=${pageMaker.startPage - 1}
                                   &amount=${cri.amount}">
                    이전
                </a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:choose>
                    <c:when test="${cri.pageNum == num}">
                        <strong>[${num}]</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="/free/list?pageNum=${num}
                                           &amount=${cri.amount}">
                            [${num}]
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <a href="/free/list?pageNum=${pageMaker.endPage + 1}
                                   &amount=${cri.amount}">
                    다음
                </a>
            </c:if>

        </div>
    </c:if>
</body>
</html>