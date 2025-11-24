<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 목록</title>

<!-- 공통 메인 스타일 -->
<link rel="stylesheet" href="${cp}/resources/css/main.css">
<!-- 레시피 목록 전용 스타일 -->
<link rel="stylesheet" href="${cp}/resources/css/recipe_list.css">
</head>
<body>

<!-- ===== 상단 네비게이션 ===== -->
<header class="tc-header">
    <div class="tc-header-inner">
        <a class="tc-logo" href="${cp}/">
            TEAM C
        </a>

        <nav class="tc-nav">
            <a href="${cp}/">메인</a>
            <a class="active" href="${cp}/recipe/list">레시피</a>
            <a href="${cp}/free/list">자유게시판</a>

            <c:if test="${not empty member}">
                <a href="${cp}/member/mypage">마이페이지</a>
            </c:if>
        </nav>

        <div class="tc-user">
            <c:if test="${not empty member}">
                <span class="tc-user-name">
                    <c:out value="${member.username}"/>님
                </span>
                <a class="tc-btn ghost" href="${cp}/member/logout">로그아웃</a>
            </c:if>
            <c:if test="${empty member}">
                <a class="tc-btn ghost" href="${cp}/member/login">로그인</a>
                <a class="tc-btn" href="${cp}/member/join">회원가입</a>
            </c:if>
        </div>
    </div>
</header>

<main class="tc-container">

    <!-- ===== 타이틀/설명 ===== -->
    <section class="tc-hero">
        <h1>레시피 목록</h1>
        <p>냉장고 재료 기반 추천/인기 레시피를 한 번에!</p>
    </section>

    <!-- ===== 상단 액션 영역 ===== -->
    <section class="tc-actions">

        <div class="tc-action-left">
            <a class="tc-btn small" href="${cp}/recipe/list">전체 목록</a>
            <c:if test="${not empty member}">
                <a class="tc-btn small primary" href="${cp}/recipe/register">레시피 등록</a>
            </c:if>
        </div>

        <!-- 정렬 -->
        <div class="tc-sort">
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

            <a class="tc-pill ${cri.sort == 'likes' ? '' : 'active'}" href="${sortNewestUrl}">
                최신순
            </a>
            <a class="tc-pill ${cri.sort == 'likes' ? 'active' : ''}" href="${sortLikesUrl}">
                인기순(좋아요)
            </a>
        </div>

        <!-- 검색 -->
        <form class="tc-search" action="${cp}/recipe/list" method="get">
            <select name="type">
                <option value="T" ${cri.type == 'T' ? 'selected' : ''}>제목</option>
                <option value="G" ${cri.type == 'G' ? 'selected' : ''}>태그</option>
                <option value="W" ${cri.type == 'W' ? 'selected' : ''}>작성자</option>
            </select>
            <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${cri.keyword}">
            <button type="submit" class="tc-btn small">검색</button>

            <!-- 상태 유지 -->
            <input type="hidden" name="pageNum" value="1">
            <input type="hidden" name="amount" value="${cri.amount}">
            <input type="hidden" name="sort" value="${cri.sort}">
            <input type="hidden" name="category" value="${cri.category}">
            <input type="hidden" name="tag" value="${cri.tag}">
        </form>
    </section>

    <!-- ===== 카드 그리드 ===== -->
    <section class="tc-grid">
        <c:forEach items="${list}" var="recipe">

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

            <article class="tc-card" onclick="location.href='${cp}${readUrl}'">
                <div class="tc-card-img">
                    <c:choose>
                        <c:when test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진">
                        </c:when>
                        <c:otherwise>
                            <div class="tc-card-img-placeholder">No Image</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="tc-card-body">
                    <h3 class="tc-card-title">
                        <c:out value="${recipe.title}" />
                    </h3>

                    <div class="tc-card-meta">
                        <span class="writer">
                            <c:out value="${recipe.writerName}" />
                        </span>
                        <span class="likes">❤ <c:out value="${recipe.like_count}" /></span>
                    </div>

                    <div class="tc-card-sub">
                        <span>
                            1인분 식비:
                            <c:choose>
                                <c:when test="${not empty recipe.cost}">
                                    <fmt:formatNumber value="${recipe.cost}" pattern="#,##0"/>원
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </span>
                        <span>
                            · 소요시간:
                            <c:choose>
                                <c:when test="${not empty recipe.time_required}">
                                    <c:out value="${recipe.time_required}" />
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="tc-card-date">
                        <fmt:formatDate pattern="yyyy-MM-dd" value="${recipe.regdate}" />
                    </div>
                </div>
            </article>

        </c:forEach>
    </section>

    <!-- ===== 페이징 ===== -->
    <c:if test="${not empty pageMaker}">
        <nav class="tc-pagination">

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
                <a class="tc-page-btn" href="${cp}${prevUrl}">이전</a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:url var="pageUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${num}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                    <c:param name="category" value="${cri.category}" />
                    <c:param name="tag" value="${cri.tag}" />
                </c:url>

                <a class="tc-page-num ${cri.pageNum == num ? 'active' : ''}" href="${cp}${pageUrl}">
                    ${num}
                </a>
            </c:forEach>

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
                <a class="tc-page-btn" href="${cp}${nextUrl}">다음</a>
            </c:if>

        </nav>
    </c:if>

</main>

</body>
</html>