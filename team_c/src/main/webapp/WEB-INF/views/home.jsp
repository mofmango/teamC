<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="extraCss" value="home.css"/>
<c:set var="pageTitle" value="메인"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<!-- 컨텍스트 경로 -->
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- ================== HERO 영역 ================== -->
<section class="tc-hero">
    <div class="tc-hero-inner">

        <!-- 왼쪽 : 타이틀 + 검색 -->
        <div class="tc-hero-left">
            <h1 class="tc-hero-title">TEAM_C Recipe Platform</h1>
            <p class="tc-hero-sub">냉장고 속 재료로 오늘의 레시피를 추천받아보세요.</p>

            <!-- 빠른 검색 (레시피 리스트 검색과 동일) -->
            <form class="tc-searchbar" action="${ctx}/recipe/list" method="get">
                <select name="type" class="tc-select">
                    <option value="T" ${cri.type == 'T' ? 'selected' : ''}>제목</option>
                    <option value="C" ${cri.type == 'C' ? 'selected' : ''}>내용</option>
                    <option value="W" ${cri.type == 'W' ? 'selected' : ''}>작성자</option>
                    <option value="TC" ${cri.type == 'TC' ? 'selected' : ''}>제목+내용</option>
                </select>
                <input type="text" name="keyword" class="tc-input"
                       placeholder="검색어를 입력하세요" value="${cri.keyword}">
                <button type="submit" class="tc-btn tc-btn-primary">검색</button>
            </form>

            <!-- 태그 칩 -->
            <c:if test="${not empty quickTags}">
                <div class="tc-chip-row">
                    <c:forEach items="${quickTags}" var="tag">
                        <a href="${ctx}/recipe/list?tag=${tag}" class="tc-chip">#${tag}</a>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- 오른쪽 : 대표 레시피 카드 -->
        <div class="tc-hero-right">
            <div class="tc-card tc-card-hero">
                <c:choose>
                    <c:when test="${not empty heroRecipe}">
                        <div class="tc-card-img">
                            <c:choose>
                                <c:when test="${not empty heroRecipe.image_path}">
                                    <img src="${heroRecipe.image_path}" alt="대표 레시피">
                                </c:when>
                                <c:otherwise>
                                    <div class="tc-card-noimg">NO IMAGE</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="tc-card-body">
                            <div class="tc-card-title">
                                <c:out value="${heroRecipe.title}"/>
                            </div>
                            <div class="tc-card-meta">
                                <span class="tc-like">❤️ <c:out value="${heroRecipe.like_count}"/></span>
                                <span>· <c:out value="${heroRecipe.writer}"/></span>
                            </div>
                            <a class="tc-more" href="${ctx}/recipe/get?bno=${heroRecipe.bno}">상세보기 →</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="tc-empty">
                            <div>NO RECIPES YET</div>
                            <div style="margin-top:6px;">최근 레시피가 아직 없어요.</div>
                            <div style="margin-top:10px;">
                                <a href="${ctx}/recipe/register" class="tc-more">레시피 등록 →</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</section>

<!-- ================== 내 냉장고 재료 기반 추천 (캐러셀) ================== -->
<section class="tc-section">
    <div class="tc-section-head">
        <div>
            <h2 class="tc-section-title">내 냉장고 재료 기반 추천</h2>
            <p class="tc-section-sub">보유 재료/태그 매칭률이 높은 레시피부터 보여줘요.</p>
        </div>
    </div>

    <c:choose>
        <%-- 로그인 안 한 경우 --%>
        <c:when test="${empty member}">
            <div class="tc-empty">
                로그인하면 냉장고 재료 기반 추천을 받을 수 있어요.
                <div style="margin-top:8px;">
                    <a href="${ctx}/member/login" class="tc-btn tc-btn-primary">로그인</a>
                </div>
            </div>
        </c:when>

        <%-- 로그인 했지만 추천이 없는 경우 --%>
        <c:when test="${empty recommendList}">
            <div class="tc-empty">
                내 냉장고 재료와 매칭되는 레시피가 아직 없어요.
            </div>
        </c:when>

        <%-- 추천 레시피 캐러셀 (최대 3개) --%>
        <c:otherwise>
            <div class="tc-reco-carousel">
                <button type="button" class="tc-reco-btn tc-reco-prev">‹</button>

                <div class="tc-reco-viewport">
                    <div class="tc-reco-track">
                        <c:forEach items="${recommendList}" var="r" varStatus="st">
                            <c:if test="${st.index lt 3}">
                                <a href="${ctx}/recipe/get?bno=${r.bno}" class="tc-card tc-reco-card">
                                    <div class="tc-card-img">
                                        <c:choose>
                                            <c:when test="${not empty r.image_path}">
                                                <img src="${r.image_path}" alt="thumb">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="tc-card-noimg">NO IMAGE</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="tc-card-body">
                                        <div class="tc-card-title">
                                            <c:out value="${r.title}"/>
                                        </div>
                                        <div class="tc-card-meta">
                                            <span class="tc-like">❤️ <c:out value="${r.like_count}"/></span>
                                            <span><c:out value="${r.writer}"/></span>
                                        </div>
                                    </div>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <button type="button" class="tc-reco-btn tc-reco-next">›</button>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<!-- ================== 최근 올라온 레시피 ================== -->
<section class="tc-section">
    <div class="tc-section-head">
        <h2 class="tc-section-title">최근 올라온 레시피</h2>
        <a href="${ctx}/recipe/list" class="tc-more">전체보기 →</a>
    </div>

    <c:choose>
        <c:when test="${empty recentList}">
            <div class="tc-empty">최근 레시피가 아직 없어요.</div>
        </c:when>

        <c:otherwise>
            <div class="tc-card-grid">
                <c:forEach items="${recentList}" var="r">
                    <a href="${ctx}/recipe/get?bno=${r.bno}" class="tc-card">
                        <div class="tc-card-img">
                            <c:choose>
                                <c:when test="${not empty r.image_path}">
                                    <img src="${r.image_path}" alt="thumb">
                                </c:when>
                                <c:otherwise>
                                    <div class="tc-card-noimg">NO IMAGE</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="tc-card-body">
                            <div class="tc-card-title"><c:out value="${r.title}"/></div>
                            <div class="tc-card-meta">
                                <span class="tc-like">❤️ <c:out value="${r.like_count}"/></span>
                                <span><c:out value="${r.writer}"/></span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<!-- ================== 자유게시판 ================== -->
<section class="tc-section">
    <div class="tc-section-head">
        <h2 class="tc-section-title">자유게시판</h2>
        <a href="${ctx}/free/list" class="tc-more">보러가기 →</a>
    </div>

    <c:choose>
        <c:when test="${empty recentFreeList}">
            <div class="tc-empty">자유게시판 글이 아직 없어요.</div>
        </c:when>

        <c:otherwise>
            <div class="tc-col">
                <ul class="tc-free-list">
                    <c:forEach items="${recentFreeList}" var="f">
                        <li class="tc-free-item">
                            <a href="${ctx}/free/get?bno=${f.bno}" class="tc-link">
                                <strong><c:out value="${f.title}"/></strong>
                            </a>
                            <span style="margin-left:6px; font-size:12px; opacity:.8;">
                                · <c:out value="${f.writer}"/>
                            </span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<!-- ================== 빠른 이동 ================== -->
<section class="tc-section">
    <div class="tc-section-head">
        <h2>빠른 이동</h2>
    </div>
    <div class="tc-quick-grid">
        <a href="${ctx}/recipe/register" class="tc-quick">레시피 등록</a>
        <a href="${ctx}/member/mypage" class="tc-quick">마이페이지</a>
        <a href="${ctx}/free/register" class="tc-quick">자유게시판 글쓰기</a>
    </div>
</section>

<!-- 캐러셀 스크립트 -->
<script>
(function() {
    const carousel = document.querySelector('.tc-reco-carousel');
    if (!carousel) return;

    const track  = carousel.querySelector('.tc-reco-track');
    const cards  = carousel.querySelectorAll('.tc-reco-card');
    const prev   = carousel.querySelector('.tc-reco-prev');
    const next   = carousel.querySelector('.tc-reco-next');

    if (cards.length === 0) {
        prev.style.display = 'none';
        next.style.display = 'none';
        return;
    }

    // 한 화면에 1개씩 넘기는 느낌 (최대 3개)
    const visibleCount = 1;
    let index = 0;

    function update() {
        const card = cards[0];
        if (!card) return;

        const style = window.getComputedStyle(card);
        const gap = parseInt(style.marginRight || '16', 10);
        const cardWidth = card.offsetWidth + gap;

        track.style.transform = 'translateX(' + (-index * cardWidth) + 'px)';

        prev.disabled = (index === 0);
        next.disabled = (index >= Math.max(0, cards.length - visibleCount));
    }

    prev.addEventListener('click', function() {
        if (index > 0) {
            index--;
            update();
        }
    });

    next.addEventListener('click', function() {
        if (index < cards.length - visibleCount) {
            index++;
            update();
        }
    });

    window.addEventListener('resize', update);
    update();
})();
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>