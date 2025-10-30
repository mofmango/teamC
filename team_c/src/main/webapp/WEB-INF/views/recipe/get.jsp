<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 상세 정보</title>
</head>
<body>

    <h1>레시피 상세 정보</h1>
    
    <div>
        <label>글번호</label>
        <input type="text" value="<c:out value='${recipe.bno}'/>" readonly>
    </div>
    <div>
        <label>제목</label>
        <input type="text" value="<c:out value='${recipe.title}'/>" readonly>
    </div>
    
    <h3>재료</h3>
    <div style="white-space: pre-wrap;">${recipe.ingredients}</div>
    
    <hr>
	<h3>영양 정보 (총 합계)</h3>
	<table border="1">
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
	
	<hr>
    <h3>조리 과정</h3>
    <c:forEach items="${recipe.steps}" var="step">
        <div style="margin-top: 20px; border-bottom: 1px dotted #ccc; padding-bottom: 20px;">
            <h4>Step ${step.step_order}</h4>
            <p><c:out value="${step.description}"/></p>
            <c:if test="${not empty step.image_path}">
                <img src="${step.image_path}" alt="Step ${step.step_order} 사진" style="max-width: 300px;">
            </c:if>
        </div>
    </c:forEach>
    <hr>

    <div>
        <label>대표 이미지</label>
        <div>
            <c:if test="${not empty recipe.image_path}">
                <img src="${recipe.image_path}" alt="요리 사진" style="max-width: 300px;">
            </c:if>
        </div>
    </div>
    <div>
        <label>작성자</label>
        <a href="/member/userpage?userid=${recipe.writer}">
            <strong><c:out value="${recipe.writerName}"/></strong>
        </a>
        
        <c:if test="${not empty member and member.userid != recipe.writer}">
            <button id="followBtn" data-writer="${recipe.writer}">
                <c:choose>
                    <c:when test="${isFollowing}">팔로잉</c:when>
                    <c:otherwise>팔로우</c:otherwise>
                </c:choose>
            </button>
        </c:if>
    </div>

    <div>
        <label>태그</label>
        <div>
            <c:forEach items="${tagList}" var="tag">
                <a href="/recipe/list?tag=${tag}" style="text-decoration: none;">
                    <span style="background-color: #eee; padding: 2px 5px; border-radius: 5px; margin-right: 5px;">
                        #<c:out value="${tag}"/>
                    </span>
                </a>
            </c:forEach>
        </div>
    </div>
    <hr>

    <div>
        <button id="likeBtn">좋아요</button>
        <span id="likeCount">${recipe.like_count}</span>
        <button id="bookmarkBtn">북마크</button>
    </div>
    <br>
    <div>
        <c:if test="${member.userid == recipe.writer}">
            <button type="button" 
                onclick="location.href='/recipe/modify?bno=${recipe.bno}'">수정</button>
            <form action="/recipe/remove" method="post" style="display: inline;">
                <input type="hidden" name="bno" value="${recipe.bno}">
                <button type="submit">삭제</button>
            </form>
        </c:if>
        <c:if test="${not empty member and member.userid != recipe.writer}">
	        <a href="/report/register?bno=${recipe.bno}&reported_id=${recipe.writer}">
	            <button style="color: red;">신고</button>
	        </a>
	    </c:if>
        
        <button type="button" onclick="location.href='/recipe/list'">전체 목록으로</button>
    </div>
    
    <hr>
    <h3>댓글</h3>
    
    <form action="/comment/register" method="post">
        <input type="hidden" name="bno" value="${recipe.bno}">
        <input type="hidden" name="replyer" value="${member.userid}">
        <textarea name="reply" rows="3" cols="50" placeholder="댓글을 입력하세요" <c:if test="${empty member}">disabled</c:if> ></textarea>
        <button type="submit" <c:if test="${empty member}">disabled</c:if> >댓글 등록</button>
    </form>
    
    <br>
    
    <div>
        <ul>
            <c:forEach items="${commentList}" var="comment">
                <li>
                    <a href="/member/userpage?userid=${comment.replyer}">
                        <strong><c:out value="${comment.replyer}"/></strong>
                    </a>:
                    <c:out value="${comment.reply}"/>
                    &nbsp; (<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${comment.replyDate}"/>)
                </li>
            </c:forEach>
        </ul>
    </div>
    
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    
    $('#likeBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/like/' + bno,
            success: function(result) {
                $('#likeCount').text(result.likeCount);
                if(result.userLiked) { $('#likeBtn').css('background-color', 'pink'); } 
                else { $('#likeBtn').css('background-color', ''); }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); location.href = "/member/login"; }
            }
        });
    });
    
    $('#bookmarkBtn').on('click', function() {
        var bno = ${recipe.bno};
        $.ajax({
            type: 'post', url: '/bookmark/' + bno,
            success: function(result) {
                if(result.userBookmarked) { alert("북마크에 추가되었습니다."); $('#bookmarkBtn').css('background-color', 'gold'); } 
                else { alert("북마크가 취소되었습니다."); $('#bookmarkBtn').css('background-color', ''); }
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
                if(result.isFollowing) { $('#followBtn').text('팔로잉'); } 
                else { $('#followBtn').text('팔로우'); }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); }
            }
        });
    });
});
</script>
</body>
</html>