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

    <!-- 정렬 링크: sort 바꾸면서 나머지 검색 조건은 그대로 유지 -->
    <div style="margin-top: 10px;">
        <strong>정렬:</strong>
        <c:url var="sortNewestUrl" value="/recipe/list">
            <c:param name="sort" value="newest" />
            <c:param name="pageNum" value="1" />
            <c:param name="amount" value="${cri.amount}" />
            <c:param name="type" value="${cri.type}" />
            <c:param name="keyword" value="${cri.keyword}" />
            <c:param name="category" value="${cri.category}" />
            <c:param name="tag" value="${cri.tag}" />
        </c:url>
        <c:url var="sortLikesUrl" value="/recipe/list">
            <c:param name="sort" value="likes" />
            <c:param name="pageNum" value="1" />
            <c:param name="amount" value="${cri.amount}" />
            <c:param name="type" value="${cri.type}" />
            <c:param name="keyword" value="${cri.keyword}" />
            <c:param name="category" value="${cri.category}" />
            <c:param name="tag" value="${cri.tag}" />
        </c:url>

        <a href="${sortNewestUrl}">최신순</a> |
        <a href="${sortLikesUrl}">인기순(좋아요순)</a>
    </div>

    <!-- 검색 폼 -->
    <form action="/recipe/list" method="get" style="margin-top: 10px;">
        <select name="type">
            <option value="T" ${cri.type == 'T' ? 'selected' : ''}>제목</option>
            <option value="G" ${cri.type == 'G' ? 'selected' : ''}>태그</option>
            <option value="W" ${cri.type == 'W' ? 'selected' : ''}>작성자</option>
        </select>
        <input type="text" name="keyword" placeholder="검색어" value="${cri.keyword}">
        <button type="submit">검색</button>
        <input type="hidden" name="pageNum" value="1">
        <input type="hidden" name="amount" value="${cri.amount}">
        <input type="hidden" name="sort" value="${cri.sort}">
        <input type="hidden" name="category" value="${cri.category}">
        <input type="hidden" name="tag" value="${cri.tag}">
    </form>
    <br>

    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>번호</th>
                <th>이미지</th>
                <th>제목</th>
                <th>작성자</th>
                <!-- ✅ 추가 -->
                <th>1인분 식비</th>
                <th>소요시간</th>
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
                        <!-- ★ 상세 페이지 링크에 Criteria 다 붙여서 전송 -->
                        <c:url var="readUrl" value="/recipe/get">
                            <c:param name="bno" value="${recipe.bno}" />
                            <c:param name="pageNum" value="${cri.pageNum}" />
                            <c:param name="amount" value="${cri.amount}" />
                            <c:param name="sort" value="${cri.sort}" />
                            <c:param name="type" value="${cri.type}" />
                            <c:param name="keyword" value="${cri.keyword}" />
                            <c:param name="category" value="${cri.category}" />
                            <c:param name="tag" value="${cri.tag}" />
                        </c:url>
                        <a href="${readUrl}">
                            <c:out value="${recipe.title}"/>
                        </a>
                    </td>
                    <td><c:out value="${recipe.writerName}"/></td>

                    <!-- ✅ 1인분 식비 표시 -->
                    <td>
                        <c:choose>
                            <c:when test="${not empty recipe.cost}">
                                <fmt:formatNumber value="${recipe.cost}" pattern="#,##0"/> 원
                            </c:when>
                            <c:otherwise>
                                정보 없음
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- ✅ 소요시간 표시 -->
                    <td>
                        <c:choose>
                            <c:when test="${not empty recipe.time_required}">
                                <c:out value="${recipe.time_required}"/>
                            </c:when>
                            <c:otherwise>
                                정보 없음
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이징 영역 -->
    <c:if test="${not empty pageMaker}">
        <div style="margin-top: 20px; text-align: center;">

            <!-- 이전 블럭 -->
            <c:if test="${pageMaker.prev}">
                <c:url var="prevUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${pageMaker.startPage - 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                    <c:param name="category" value="${cri.category}" />
                    <c:param name="tag" value="${cri.tag}" />
                </c:url>
                <a href="${prevUrl}">이전</a>
            </c:if>

            <!-- 페이지 번호들 -->
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:choose>
                    <c:when test="${cri.pageNum == num}">
                        <strong>[${num}]</strong>
                    </c:when>
                    <c:otherwise>
                        <c:url var="pageUrl" value="/recipe/list">
                            <c:param name="pageNum" value="${num}" />
                            <c:param name="amount" value="${cri.amount}" />
                            <c:param name="sort" value="${cri.sort}" />
                            <c:param name="type" value="${cri.type}" />
                            <c:param name="keyword" value="${cri.keyword}" />
                            <c:param name="category" value="${cri.category}" />
                            <c:param name="tag" value="${cri.tag}" />
                        </c:url>
                        <a href="${pageUrl}">[${num}]</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- 다음 블럭 -->
            <c:if test="${pageMaker.next}">
                <c:url var="nextUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${pageMaker.endPage + 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                    <c:param name="category" value="${cri.category}" />
                    <c:param name="tag" value="${cri.tag}" />
                </c:url>
                <a href="${nextUrl}">다음</a>
            </c:if>

        </div>
    </c:if>

</body>
</html>