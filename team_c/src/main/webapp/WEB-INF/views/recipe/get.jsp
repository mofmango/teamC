<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="레시피 상세"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<!-- ★ 목록으로 돌아갈 때 현재 페이지/검색 조건 유지용 URL -->
<c:url var="listUrl" value="/recipe/list">
    <c:param name="pageNum" value="${cri.pageNum}" />
    <c:param name="amount" value="${cri.amount}" />
    <c:param name="sort" value="${cri.sort}" />
    <c:param name="type" value="${cri.type}" />
    <c:param name="keyword" value="${cri.keyword}" />
    <c:param name="category" value="${cri.category}" />
    <c:param name="tag" value="${cri.tag}" />
</c:url>

<section class="tc-section">
    <h1 class="tc-page-title">레시피 상세 정보</h1>

    <!-- 대표 이미지 + 기본 정보 -->
    <div class="tc-detail">
        <div class="tc-detail-left">
            <div class="tc-detail-img">
                <c:if test="${not empty recipe.image_path}">
                    <img src="${recipe.image_path}" alt="요리 사진">
                </c:if>
                <c:if test="${empty recipe.image_path}">
                    <div class="tc-empty-img">NO IMAGE</div>
                </c:if>
            </div>
        </div>

        <div class="tc-detail-right">
            <div class="tc-detail-row">
                <span class="tc-label">글번호</span>
                <span class="tc-value"><c:out value="${recipe.bno}"/></span>
            </div>

            <div class="tc-detail-row">
                <span class="tc-label">제목</span>
                <span class="tc-value tc-title"><c:out value="${recipe.title}"/></span>
            </div>

            <!-- ✅ 1인분 식비 표시 -->
            <div class="tc-detail-row">
                <span class="tc-label">1인분 식비</span>
                <span class="tc-value">
                    <c:choose>
                        <c:when test="${not empty recipe.cost}">
                            <fmt:formatNumber var="costFmt" value="${recipe.cost}" pattern="#,##0"/>
                            ${costFmt} 원
                        </c:when>
                        <c:otherwise>정보 없음</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- ✅ 소요시간 표시 -->
            <div class="tc-detail-row">
                <span class="tc-label">소요시간</span>
                <span class="tc-value">
                    <c:choose>
                        <c:when test="${not empty recipe.time_required}">
                            <c:out value="${recipe.time_required}"/>
                        </c:when>
                        <c:otherwise>정보 없음</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- 작성자 + 팔로우 -->
            <div class="tc-detail-row">
                <span class="tc-label">작성자</span>
                <span class="tc-value">
                    <a class="tc-link" href="/member/userpage?userid=${recipe.writer}">
                        <strong><c:out value="${recipe.writerName}"/></strong>
                    </a>

                    <c:if test="${not empty member and member.userid != recipe.writer}">
                        <button id="followBtn" class="tc-btn tc-btn-sm tc-btn-ghost" data-writer="${recipe.writer}">
                            <c:choose>
                                <c:when test="${isFollowing}">팔로잉</c:when>
                                <c:otherwise>팔로우</c:otherwise>
                            </c:choose>
                        </button>
                    </c:if>
                </span>
            </div>

            <!-- 태그 -->
            <div class="tc-detail-row">
                <span class="tc-label">태그</span>
                <div class="tc-tag-row">
                    <c:forEach items="${tagList}" var="tag">
                        <a href="/recipe/list?tag=${tag}" class="tc-tag-chip">
                            #<c:out value="${tag}"/>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- 좋아요/북마크 -->
            <div class="tc-actions">
                <button id="likeBtn" class="tc-btn tc-btn-sm">좋아요</button>
                <span id="likeCount" class="tc-like-count">${recipe.like_count}</span>
                <button id="bookmarkBtn" class="tc-btn tc-btn-sm tc-btn-ghost">북마크</button>
            </div>

            <!-- 수정/삭제/신고/목록 -->
            <div class="tc-actions">
                <c:if test="${member.userid == recipe.writer}">
                    <button type="button" class="tc-btn tc-btn-sm"
                        onclick="location.href='/recipe/modify?bno=${recipe.bno}'">수정</button>

                    <form action="/recipe/remove" method="post" style="display:inline;">
                        <input type="hidden" name="bno" value="${recipe.bno}">
                        <button type="submit" class="tc-btn tc-btn-sm tc-btn-ghost">삭제</button>
                    </form>
                </c:if>

                <c:if test="${not empty member and member.userid != recipe.writer}">
                    <a href="/report/register?bno=${recipe.bno}&reported_id=${recipe.writer}">
                        <button class="tc-btn tc-btn-sm tc-btn-danger">신고</button>
                    </a>
                </c:if>

                <button type="button" class="tc-btn tc-btn-sm tc-btn-ghost"
                    onclick="location.href='${listUrl}'">목록으로</button>
            </div>
        </div>
    </div>
</section>

<!-- 재료 -->
<section class="tc-section">
    <h2 class="tc-section-title">재료</h2>
    <div class="tc-box" style="white-space: pre-wrap;">
        ${recipe.ingredients}
    </div>
</section>

<!-- 영양 정보 -->
<section class="tc-section">
    <h2 class="tc-section-title">영양 정보 (총 합계)</h2>
    <table class="tc-table">
        <tr>
            <th>칼로리</th>
            <td><fmt:formatNumber value="${nutrition.calories}" pattern="#,##0.0"/> kcal</td>
        </tr>
        <tr>
            <th>탄수화물</th>
            <td><fmt:formatNumber value="${nutrition.carbohydrate}" pattern="#,##0.0"/> g</td>
        </tr>
        <tr>
            <th>단백질</th>
            <td><fmt:formatNumber value="${nutrition.protein}" pattern="#,##0.0"/> g</td>
        </tr>
        <tr>
            <th>지방</th>
            <td><fmt:formatNumber value="${nutrition.fat}" pattern="#,##0.0"/> g</td>
        </tr>
    </table>
</section>

<!-- 조리 과정 -->
<section class="tc-section">
    <h2 class="tc-section-title">조리 과정</h2>

    <div class="tc-step-list">
        <c:forEach items="${recipe.steps}" var="step">
            <div class="tc-step-card">
                <h4 class="tc-step-title">Step ${step.step_order}</h4>
                <p class="tc-step-desc"><c:out value="${step.description}"/></p>

                <c:if test="${not empty step.image_path}">
                    <div class="tc-step-img">
                        <img src="${step.image_path}" alt="Step ${step.step_order} 사진">
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</section>

<!-- 댓글 -->
<section class="tc-section">
    <h2 class="tc-section-title">댓글</h2>

    <form action="/comment/register" method="post" class="tc-comment-form">
        <input type="hidden" name="bno" value="${recipe.bno}">
        <input type="hidden" name="replyer" value="${member.userid}">
        <textarea name="reply" rows="3" class="tc-textarea"
                  placeholder="댓글을 입력하세요"
                  <c:if test="${empty member}">disabled</c:if> ></textarea>
        <button type="submit" class="tc-btn tc-btn-sm"
                <c:if test="${empty member}">disabled</c:if> >댓글 등록</button>
    </form>

    <div class="tc-comment-list">
        <ul>
            <c:forEach items="${commentList}" var="comment">
                <li class="tc-comment-item">
                    <a class="tc-link" href="/member/userpage?userid=${comment.replyer}">
                        <strong><c:out value="${comment.replyer}"/></strong>
                    </a>
                    <span class="tc-comment-text">: <c:out value="${comment.reply}"/></span>
                    <span class="tc-comment-date">
                        (<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${comment.replyDate}"/>)
                    </span>
                </li>
            </c:forEach>
        </ul>
    </div>
</section>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {

    $('#likeBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/like/' + bno,
            success: function(result) {
                $('#likeCount').text(result.likeCount);
                if(result.userLiked) {
                    $('#likeBtn').addClass('active');
                } else {
                    $('#likeBtn').removeClass('active');
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) {
                    alert("로그인이 필요합니다.");
                    location.href = "/member/login";
                }
            }
        });
    });

    $('#bookmarkBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/bookmark/' + bno,
            success: function(result) {
                if(result.userBookmarked) {
                    alert("북마크에 추가되었습니다.");
                    $('#bookmarkBtn').addClass('active');
                } else {
                    alert("북마크가 취소되었습니다.");
                    $('#bookmarkBtn').removeClass('active');
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); }
            }
        });
    });

    $('#followBtn').on('click', function() {
        var followingId = $(this).data('writer');
        $.ajax({
            type: 'post', url: '/follow/' + followingId,
            success: function(result) {
                if(result.isFollowing) {
                    $('#followBtn').text('팔로잉');
                } else {
                    $('#followBtn').text('팔로우');
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); }
            }
        });
    });
});
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>