<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 
    [스타일 정의] 
    헤더는 건드리지 않고, 본문(.tc-page-section)만 중앙 정렬합니다.
--%>
<style>
    /* 1. Body는 전체 너비 사용 (헤더 깨짐 방지) */
    body.tc-main-page {
        display: block !important;
        width: 100% !important;
        margin: 0 !important;
        background-color: #141518 !important;
    }

    /* 2. 본문 영역만 중앙 정렬 및 너비 제한 */
    .tc-page-section {
        width: 100%;
        max-width: 1080px; /* 컨텐츠 최대 너비 */
        margin: 40px auto; /* 상하 40px, 좌우 자동(중앙 정렬) */
        padding: 0 20px;   /* 모바일에서 여백 확보 */
        box-sizing: border-box;
    }

    /* 3. 태그 디자인 개선 (잘 보이게) */
    .tc-tag-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-bottom: 24px;
    }
    .tc-tag {
        display: inline-block;
        font-size: 14px;
        font-weight: 600;
        color: #ffffff !important;
        background-color: #3b82f6 !important; /* 밝은 파랑 */
        padding: 8px 16px;
        border-radius: 99px;
        text-decoration: none;
        border: 1px solid transparent;
        transition: all 0.2s;
    }
    .tc-tag:hover {
        background-color: #2563eb !important;
        transform: translateY(-2px);
    }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="레시피 상세"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<c:url var="listUrl" value="/recipe/list">
    <c:param name="pageNum" value="${cri.pageNum}" />
    <c:param name="amount" value="${cri.amount}" />
    <c:param name="sort" value="${cri.sort}" />
    <c:param name="type" value="${cri.type}" />
    <c:param name="keyword" value="${cri.keyword}" />
    <c:param name="category" value="${cri.category}" />
    <c:param name="tag" value="${cri.tag}" />
</c:url>

<section class="tc-page-section">
    
    <div class="tc-page-head">
        <h1 class="tc-page-title">레시피 상세</h1>
        <p class="tc-page-sub">나만의 레시피를 확인하고 공유해보세요.</p>
    </div>

    <div class="tc-detail-layout">
        
        <div class="tc-detail-media">
            <c:if test="${not empty recipe.image_path}">
                <img src="${recipe.image_path}" alt="요리 사진">
            </c:if>
            <c:if test="${empty recipe.image_path}">
                <div class="tc-detail-media-empty">이미지가 없습니다</div>
            </c:if>
        </div>

        <div class="tc-detail-main">
            <div>
                <div class="tc-detail-title-row">
                    <span class="tc-detail-badge">No. <c:out value="${recipe.bno}"/></span>
                    <h2 class="tc-detail-title"><c:out value="${recipe.title}"/></h2>
                </div>

                <div class="tc-detail-meta-row">
                    <span>작성자 <strong><c:out value="${recipe.writerName}"/></strong></span>
                    
                    <c:if test="${not empty member and member.userid != recipe.writer}">
                        <button id="followBtn" class="tc-btn tc-btn-sm tc-btn-ghost" data-writer="${recipe.writer}" style="border:1px solid var(--border);">
                            <c:choose>
                                <c:when test="${isFollowing}">팔로잉</c:when>
                                <c:otherwise>팔로우</c:otherwise>
                            </c:choose>
                        </button>
                    </c:if>
                </div>

                <div class="tc-detail-meta-row">
                    <span><fmt:formatDate pattern="yyyy.MM.dd" value="${recipe.regdate}"/></span>
                </div>

                <hr class="tc-divider">

                <div class="tc-spec-grid">
                    <div class="tc-spec-item">
                        <span class="label">1인분 예상 식비</span>
                        <span class="value">
                            <c:choose>
                                <c:when test="${not empty recipe.cost}">
                                    <fmt:formatNumber value="${recipe.cost}" pattern="#,##0"/>원
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="tc-spec-item">
                        <span class="label">소요 시간</span>
                        <span class="value">
                            <c:out value="${recipe.time_required}" default="-"/>
                        </span>
                    </div>
                </div>

                <div class="tc-tag-list">
                    <c:forEach items="${tagList}" var="tag">
                        <a href="/recipe/list?tag=${tag}" class="tc-tag">#<c:out value="${tag}"/></a>
                    </c:forEach>
                </div>
            </div>

            <div class="tc-action-group">
                <button id="likeBtn" class="tc-btn tc-btn-outline" style="flex:1;">
                    ❤ 좋아요 <span id="likeCount" style="margin-left:6px">${recipe.like_count}</span>
                </button>
                <button id="bookmarkBtn" class="tc-btn tc-btn-outline" style="flex:1;">
                    🔖 북마크
                </button>
            </div>
            
            <div style="margin-top: 16px; display: flex; justify-content: space-between;">
                 <button type="button" class="tc-btn tc-btn-sm tc-btn-ghost" onclick="location.href='${listUrl}'">목록으로</button>
                 
                 <div>
                    <c:if test="${member.userid == recipe.writer}">
                        <button type="button" class="tc-btn tc-btn-sm tc-btn-primary" onclick="location.href='/recipe/modify?bno=${recipe.bno}'">수정</button>
                        <form action="/recipe/remove" method="post" style="display:inline;">
                            <input type="hidden" name="bno" value="${recipe.bno}">
                            <button type="submit" class="tc-btn tc-btn-sm tc-btn-ghost" style="color:var(--danger);" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
                        </form>
                    </c:if>
                    <c:if test="${not empty member and member.userid != recipe.writer}">
                        <a href="/report/register?bno=${recipe.bno}&reported_id=${recipe.writer}" class="tc-btn tc-btn-sm tc-btn-ghost" style="color:var(--danger);">신고</a>
                    </c:if>
                 </div>
            </div>

        </div>
    </div>

    <div class="tc-box-grid">
        <div class="tc-box">
            <h3 class="tc-box-title">재료</h3>
            <div class="tc-box-content">
                <c:choose>
                    <c:when test="${not empty recipe.ingredients}">${recipe.ingredients}</c:when>
                    <c:otherwise>재료 정보가 없습니다.</c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="tc-box">
            <h3 class="tc-box-title">영양 정보 (1인분 기준)</h3>
            <table class="tc-table">
                <tr><th>칼로리</th><td><fmt:formatNumber value="${nutrition.calories}" pattern="#,##0.0"/> kcal</td></tr>
                <tr><th>탄수화물</th><td><fmt:formatNumber value="${nutrition.carbohydrate}" pattern="#,##0.0"/> g</td></tr>
                <tr><th>단백질</th><td><fmt:formatNumber value="${nutrition.protein}" pattern="#,##0.0"/> g</td></tr>
                <tr><th>지방</th><td><fmt:formatNumber value="${nutrition.fat}" pattern="#,##0.0"/> g</td></tr>
            </table>
        </div>
    </div>

    <h2 class="tc-page-title" style="font-size: 22px; margin-bottom:20px;">조리 과정</h2>
    <div style="margin-bottom: 60px;">
        <c:forEach items="${recipe.steps}" var="step">
            <div class="tc-step-item">
                <div class="tc-step-content">
                    <div class="tc-step-head">Step <c:out value="${step.step_order}"/></div>
                    <div class="tc-step-desc"><c:out value="${step.description}"/></div>
                </div>
                <c:if test="${not empty step.image_path}">
                    <div class="tc-step-img">
                        <img src="${step.image_path}" alt="Step Image">
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <h2 class="tc-page-title" style="font-size: 22px; margin-bottom:20px;">댓글</h2>
    
    <div class="tc-comment-input-box">
        <form action="/comment/register" method="post">
            <input type="hidden" name="bno" value="${recipe.bno}">
            <input type="hidden" name="userid" value="${member.userid}">
            
            <div style="display:flex; gap:12px; align-items:flex-start;">
                <textarea name="content" rows="2" class="tc-textarea"
                          placeholder="레시피에 대한 의견을 남겨주세요."
                          <c:if test="${empty member}">disabled</c:if>></textarea>
                <button type="submit" class="tc-btn tc-btn-primary" style="height:48px;"
                        <c:if test="${empty member}">disabled</c:if>>등록</button>
            </div>
        </form>
    </div>

    <ul class="tc-comment-list">
        <c:forEach items="${commentList}" var="comment">
            <li class="tc-comment-item">
                <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                    <a href="/member/userpage?userid=${comment.userid}" style="color:var(--text); font-weight:700; text-decoration:none;">
                        <c:out value="${comment.userid}"/>
                    </a>
                    <span style="font-size:12px; color:var(--muted);">
                        <fmt:formatDate pattern="yyyy.MM.dd HH:mm" value="${comment.regdate}"/>
                    </span>
                </div>
                <div style="font-size:15px; line-height:1.5; color:var(--text); margin-bottom:4px;">
                    <c:out value="${comment.content}"/>
                </div>
                
                <c:if test="${not empty member and (member.userid == comment.userid or member.userid == recipe.writer)}">
                    <div style="text-align:right;">
                        <button type="button" class="tc-btn-ghost comment-delete-btn"
                                data-comment-id="${comment.comment_id}" 
                                style="color:var(--danger); font-size:12px; padding:4px 8px;">삭제</button>
                    </div>
                </c:if>
            </li>
        </c:forEach>
    </ul>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    
    // 좋아요
    $('#likeBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/like/' + bno,
            success: function(result) {
                $('#likeCount').text(result.likeCount);
                if(result.userLiked) $('#likeBtn').addClass('active'); 
                else $('#likeBtn').removeClass('active');
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); location.href = "/member/login"; }
            }
        });
    });

    // 북마크
    $('#bookmarkBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/bookmark/' + bno,
            success: function(result) {
                if(result.userBookmarked) {
                    alert("북마크에 저장되었습니다.");
                    $('#bookmarkBtn').addClass('active');
                } else {
                    alert("북마크가 해제되었습니다.");
                    $('#bookmarkBtn').removeClass('active');
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) alert("로그인이 필요합니다.");
            }
        });
    });

    // 팔로우
    $('#followBtn').on('click', function() {
        var followingId = $(this).data('writer');
        $.ajax({
            type: 'post', url: '/follow/' + followingId,
            success: function(result) {
                if(result.isFollowing) $('#followBtn').text('팔로잉');
                else $('#followBtn').text('팔로우');
            },
            error: function(xhr) {
                if(xhr.status == 401) alert("로그인이 필요합니다.");
            }
        });
    });

    // 댓글 삭제
    $(document).on('click', '.comment-delete-btn', function() {
        if(!confirm("댓글을 삭제하시겠습니까?")) return;
        var commentId = $(this).data('comment-id');
        var $li = $(this).closest('li');
        $.ajax({
            type: 'post',
            url: '/comment/remove',
            data: { comment_id: commentId },
            success: function(res) {
                if(res.success){
                    $li.remove();
                } else {
                    alert("삭제 실패.");
                }
            },
            error: function() {
                alert("서버 오류");
            }
        });
    });
});
</script>