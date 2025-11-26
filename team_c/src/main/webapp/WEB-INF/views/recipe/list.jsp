<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 
    [스타일 정의] 
    recipe.css 기반의 다크 테마 리스트 디자인 적용
--%>
<style>
    /* 1. Body는 전체 너비 사용 */
    body.tc-main-page {
        display: block !important;
        width: 100% !important;
        margin: 0 !important;
        background-color: #141518 !important;
    }

    /* 2. 본문 영역만 중앙 정렬 및 너비 제한 */
    .tc-page-section {
        width: 100%;
        max-width: 1080px;
        margin: 40px auto;
        padding: 0 20px;
        box-sizing: border-box;
    }

    /* 3. 상단 액션 영역 (검색, 정렬, 등록 버튼) */
    .tc-list-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 16px;
    }
    
    .tc-search-box {
        display: flex;
        gap: 8px;
        background: #1b1d22;
        padding: 6px;
        border-radius: 8px;
        border: 1px solid #2b2f37;
    }
    .tc-search-select {
        background: transparent;
        border: none;
        color: #9ca3af;
        padding: 0 8px;
        font-size: 14px;
        outline: none;
    }
    .tc-search-input {
        background: transparent;
        border: none;
        color: #e8eaf0;
        padding: 8px;
        font-size: 14px;
        outline: none;
        width: 200px;
    }
    
    .tc-sort-tabs {
        display: flex;
        background: #1b1d22;
        padding: 4px;
        border-radius: 8px;
        border: 1px solid #2b2f37;
    }
    .tc-sort-item {
        padding: 8px 16px;
        font-size: 13px;
        color: #9ca3af;
        text-decoration: none;
        border-radius: 6px;
        transition: 0.2s;
    }
    .tc-sort-item.active {
        background: #3b82f6;
        color: white;
        font-weight: 600;
    }

    /* 4. 카드 그리드 레이아웃 */
    .tc-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
        gap: 24px;
        margin-bottom: 40px;
    }
    
    .tc-card {
        background: #1b1d22;
        border: 1px solid #2b2f37;
        border-radius: 16px;
        overflow: hidden;
        transition: transform 0.2s, box-shadow 0.2s;
        cursor: pointer;
        display: flex;
        flex-direction: column;
    }
    .tc-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        border-color: #3b82f6;
    }
    
    .tc-card-img {
        width: 100%;
        aspect-ratio: 4/3;
        background: #252830;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    .tc-card-img img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s;
    }
    .tc-card:hover .tc-card-img img {
        transform: scale(1.05);
    }
    .tc-card-empty {
        color: #9ca3af;
        font-size: 13px;
    }
    
    .tc-card-body {
        padding: 20px;
        display: flex;
        flex-direction: column;
        flex: 1;
    }
    .tc-card-title {
        font-size: 16px;
        font-weight: 700;
        color: #e8eaf0;
        margin: 0 0 8px 0;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .tc-card-writer {
        font-size: 13px;
        color: #9ca3af;
        margin-bottom: 12px;
    }
    
    .tc-card-stats {
        display: flex;
        justify-content: space-between;
        margin-top: auto;
        padding-top: 12px;
        border-top: 1px solid #2b2f37;
        font-size: 12px;
        color: #71717a;
    }
    .tc-stat-icon { margin-right: 4px; }
    
    /* 5. 버튼 및 기타 */
    .tc-btn { padding: 8px 16px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; text-decoration: none; font-size: 14px; display: inline-flex; align-items: center; justify-content: center; }
    .tc-btn-primary { background: #3b82f6; color: white; }
    .tc-btn-sm { padding: 6px 12px; font-size: 13px; }
    
    /* 페이징 */
    .tc-pagination { display: flex; justify-content: center; gap: 6px; margin-top: 40px; }
    .tc-page-btn { width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #252830; color: #9ca3af; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .tc-page-btn:hover { background: #3a3f4b; color: white; }
    .tc-page-btn.active { background: #3b82f6; color: white; font-weight: 700; }
</style>

<c:set var="cp" value="${pageContext.request.contextPath}" />
<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="레시피 목록"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    
    <div class="tc-page-head">
        <h1 class="tc-page-title" style="color:white; font-size:28px; font-weight:800; margin-bottom:8px;">레시피 목록</h1>
        <p class="tc-page-sub" style="color:#9ca3af; font-size:15px;">냉장고 속 재료로 만드는 맛있는 요리!</p>
    </div>

    <div class="tc-list-actions">
        
        <form action="${cp}/recipe/list" method="get" class="tc-search-box">
            <select name="type" class="tc-search-select">
                <option value="T" ${cri.type == 'T' ? 'selected' : ''}>제목</option>
                <option value="G" ${cri.type == 'G' ? 'selected' : ''}>태그</option>
                <option value="W" ${cri.type == 'W' ? 'selected' : ''}>작성자</option>
            </select>
            <input type="text" name="keyword" class="tc-search-input" placeholder="검색어 입력" value="${cri.keyword}">
            <button type="submit" class="tc-btn tc-btn-primary tc-btn-sm">검색</button>
            
            <input type="hidden" name="pageNum" value="1">
            <input type="hidden" name="amount" value="${cri.amount}">
            <input type="hidden" name="sort" value="${cri.sort}">
        </form>

        <div style="display:flex; gap:12px; align-items:center;">
            <div class="tc-sort-tabs">
                <c:url var="sortNewestUrl" value="/recipe/list">
                    <c:param name="sort" value="newest" />
                    <c:param name="pageNum" value="1" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                </c:url>
                <c:url var="sortLikesUrl" value="/recipe/list">
                    <c:param name="sort" value="likes" />
                    <c:param name="pageNum" value="1" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                </c:url>

                <a href="${sortNewestUrl}" class="tc-sort-item ${empty cri.sort or cri.sort == 'newest' ? 'active' : ''}">최신순</a>
                <a href="${sortLikesUrl}" class="tc-sort-item ${cri.sort == 'likes' ? 'active' : ''}">인기순</a>
            </div>

            <c:if test="${not empty member}">
                <a href="${cp}/recipe/register" class="tc-btn tc-btn-primary">레시피 등록</a>
            </c:if>
        </div>
    </div>

    <div class="tc-grid">
        <c:forEach items="${list}" var="recipe">
            
            <c:url var="readUrl" value="/recipe/get">
                <c:param name="bno" value="${recipe.bno}" />
                <c:param name="pageNum" value="${cri.pageNum}" />
                <c:param name="amount" value="${cri.amount}" />
                <c:param name="sort" value="${cri.sort}" />
                <c:param name="type" value="${cri.type}" />
                <c:param name="keyword" value="${cri.keyword}" />
            </c:url>

            <article class="tc-card" onclick="location.href='${cp}${readUrl}'">
                <div class="tc-card-img">
                    <c:choose>
                        <c:when test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진">
                        </c:when>
                        <c:otherwise>
                            <div class="tc-card-empty">No Image</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="tc-card-body">
                    <h3 class="tc-card-title"><c:out value="${recipe.title}" /></h3>
                    <div class="tc-card-writer">by <c:out value="${recipe.writerName}" /></div>
                    
                    <div class="tc-card-stats">
                        <span>
                            <c:if test="${not empty recipe.time_required}">
                                ⏱ <c:out value="${recipe.time_required}" />
                            </c:if>
                        </span>
                        <span>❤ <c:out value="${recipe.like_count}" /></span>
                    </div>
                </div>
            </article>

        </c:forEach>
    </div>

    <c:if test="${not empty pageMaker}">
        <div class="tc-pagination">
            
            <c:if test="${pageMaker.prev}">
                <c:url var="prevUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${pageMaker.startPage - 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                </c:url>
                <a href="${cp}${prevUrl}" class="tc-page-btn">Prev</a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <c:url var="pageUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${num}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                </c:url>
                <a href="${cp}${pageUrl}" class="tc-page-btn ${cri.pageNum == num ? 'active' : ''}">${num}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <c:url var="nextUrl" value="/recipe/list">
                    <c:param name="pageNum" value="${pageMaker.endPage + 1}" />
                    <c:param name="amount" value="${cri.amount}" />
                    <c:param name="sort" value="${cri.sort}" />
                    <c:param name="type" value="${cri.type}" />
                    <c:param name="keyword" value="${cri.keyword}" />
                </c:url>
                <a href="${cp}${nextUrl}" class="tc-page-btn">Next</a>
            </c:if>

        </div>
    </c:if>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>