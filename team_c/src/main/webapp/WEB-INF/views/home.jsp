<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="TEAM_C 메인"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-hero">
    <h1 class="tc-hero-title">냉장고 재료로<br/>오늘의 레시피를 찾자!</h1>
    <p class="tc-hero-sub">재료 기반 추천 + 인기 레시피까지 한 번에</p>

    <!-- 통합 검색(레시피 list로) -->
    <form action="/recipe/list" method="get" class="tc-search">
        <input type="hidden" name="pageNum" value="1"/>
        <input type="hidden" name="amount" value="10"/>
        <select name="type" class="tc-search-select">
            <option value="T">제목</option>
            <option value="G">태그</option>
            <option value="W">작성자</option>
        </select>
        <input type="text" name="keyword" class="tc-search-input" placeholder="레시피 검색어를 입력하세요"/>
        <button type="submit" class="tc-search-btn">검색</button>
    </form>

    <div class="tc-hero-actions">
        <a href="/recipe/list" class="tc-btn">레시피 보러가기</a>
        <a href="/free/list" class="tc-btn tc-btn-ghost">자유게시판 보러가기</a>
    </div>
</section>

<section class="tc-section">
    <div class="tc-section-head">
        <h2>내 냉장고 재료 기반 추천</h2>
        <c:if test="${empty member}">
            <span class="tc-muted">로그인하면 추천이 떠!</span>
        </c:if>
    </div>

    <c:if test="${not empty member}">
        <c:if test="${empty recommendList}">
            <div class="tc-empty">
                냉장고 재료가 없거나 추천 결과가 없습니다.<br/>
                <a href="/member/fridge" class="tc-btn tc-btn-sm">냉장고 재료 등록하러 가기</a>
            </div>
        </c:if>

        <c:if test="${not empty recommendList}">
            <div class="tc-card-grid">
                <c:forEach items="${recommendList}" var="r">
                    <a class="tc-card" href="/recipe/get?bno=${r.bno}">
                        <div class="tc-card-img">
                            <c:if test="${not empty r.image_path}">
                                <img src="${r.image_path}" alt="recipe">
                            </c:if>
                        </div>
                        <div class="tc-card-body">
                            <h3 class="tc-card-title"><c:out value="${r.title}"/></h3>
                            <p class="tc-card-meta">
                                <span># <c:out value="${r.writerName}"/></span>
                                <span>❤️ <c:out value="${r.like_count}"/></span>
                            </p>
                            <p class="tc-card-sub">
                                1인분 식비: <c:out value="${r.cost}"/>원 ·
                                소요시간: <c:out value="${r.time_required}"/>
                            </p>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>
    </c:if>
</section>

<section class="tc-section">
    <div class="tc-section-head">
        <h2>빠른 이동</h2>
    </div>
    <div class="tc-quick-grid">
        <a href="/recipe/register" class="tc-quick">레시피 등록</a>
        <a href="/member/mypage" class="tc-quick">마이페이지</a>
        <a href="/free/register" class="tc-quick">자유게시판 글쓰기</a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>