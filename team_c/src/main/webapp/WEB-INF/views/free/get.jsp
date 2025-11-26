<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 900px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    /* 게시글 본문 스타일 */
    .tc-view-card { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 40px; margin-bottom: 30px; }
    .tc-view-header { border-bottom: 1px solid #2b2f37; padding-bottom: 20px; margin-bottom: 20px; }
    .tc-view-title { font-size: 24px; font-weight: 800; color: white; margin: 0 0 10px 0; }
    .tc-view-meta { font-size: 14px; color: #9ca3af; display: flex; gap: 15px; }
    .tc-view-content { font-size: 16px; line-height: 1.8; color: #e8eaf0; min-height: 200px; white-space: pre-wrap; }
    
    /* 버튼 */
    .tc-btn { padding: 8px 16px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; font-size: 14px; }
    .tc-btn-primary { background: #3b82f6; color: white; }
    .tc-btn-outline { background: transparent; border: 1px solid #2b2f37; color: #9ca3af; }
    .tc-btn-danger { background: transparent; color: #ef4444; border: 1px solid #ef4444; }
    .tc-btn-sm { padding: 6px 12px; font-size: 13px; }
    .tc-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }

    /* 댓글 영역 스타일 */
    .tc-reply-section { margin-top: 50px; }
    .tc-reply-head { font-size: 18px; font-weight: 700; color: white; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
    .tc-reply-input-box { background: #252830; border: 1px solid #2b2f37; border-radius: 12px; padding: 20px; margin-bottom: 30px; }
    .tc-reply-textarea { width: 100%; background: transparent; border: none; color: #e8eaf0; resize: none; outline: none; min-height: 60px; font-size: 14px; }
    .tc-reply-btn-area { text-align: right; margin-top: 10px; }
    
    .tc-reply-list { list-style: none; padding: 0; }
    .tc-reply-item { background: #1b1d22; border-bottom: 1px solid #2b2f37; padding: 20px; display: flex; flex-direction: column; gap: 8px; }
    .tc-reply-item:first-child { border-top-left-radius: 12px; border-top-right-radius: 12px; }
    .tc-reply-item:last-child { border-bottom: none; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px; }
    .tc-reply-writer { font-weight: 700; color: white; font-size: 14px; }
    .tc-reply-date { font-size: 12px; color: #71717a; margin-left: 8px; }
    .tc-reply-content { color: #d4d4d8; font-size: 14px; line-height: 1.5; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="게시글 상세보기"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">

    <div class="tc-view-card">
        <div class="tc-view-header">
            <h1 class="tc-view-title"><c:out value='${board.title}'/></h1>
            <div class="tc-view-meta">
                <span>No. <c:out value='${board.bno}'/></span>
                <span>Writer: <c:out value='${board.writer}'/></span>
                </div>
        </div>
        
        <div class="tc-view-content"><c:out value='${board.content}'/></div>

        <div class="tc-actions">
            <button type="button" class="tc-btn tc-btn-outline" onclick="location.href='/free/list'">목록으로</button>
            
            <c:if test="${member.userid == board.writer}">
                <button type="button" class="tc-btn tc-btn-primary" onclick="location.href='/free/modify?bno=${board.bno}'">수정</button>
                <form action="/free/remove" method="post" style="display: inline;">
                    <input type="hidden" name="bno" value="${board.bno}">
                    <button type="submit" class="tc-btn tc-btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
                </form>
            </c:if>
        </div>
    </div>

    <div class="tc-reply-section">
        <div class="tc-reply-head">💬 댓글</div>

        <div class="tc-reply-input-box">
            <textarea id="replyContent" class="tc-reply-textarea" placeholder="댓글을 입력하세요..." 
                <c:if test="${empty member}">disabled</c:if>></textarea>
            <div class="tc-reply-btn-area">
                <button id="replyAddBtn" class="tc-btn tc-btn-primary tc-btn-sm" 
                    <c:if test="${empty member}">disabled</c:if>>등록</button>
            </div>
        </div>

        <ul id="replyUL" class="tc-reply-list">
            </ul>
    </div>

</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    var bnoValue = '<c:out value="${board.bno}"/>';
    var replyUL = $("#replyUL");
    
    // 현재 로그인한 사용자 ID (없으면 빈 문자열)
    var loginUser = "${member.userid}";

    showList(1); // 처음에는 1페이지 로드

    // 댓글 목록 불러오기 함수
    function showList(page) {
        // [주의] 백엔드 컨트롤러 URL에 맞춰 수정 필요 (/replies/pages/{bno}/{page})
        $.getJSON("/replies/pages/" + bnoValue + "/" + page + ".json", function(data) {
            var str = "";
            
            if(data == null || data.length == 0) {
                replyUL.html("<li class='tc-reply-item' style='text-align:center; color:#9ca3af;'>등록된 댓글이 없습니다.</li>");
                return;
            }

            for (var i = 0, len = data.length || 0; i < len; i++) {
                str += "<li class='tc-reply-item' data-rno='" + data[i].rno + "'>";
                str += "  <div style='display:flex; justify-content:space-between;'>";
                str += "    <div><span class='tc-reply-writer'>" + data[i].replyer + "</span>";
                str += "    <span class='tc-reply-date'>" + displayTime(data[i].replyDate) + "</span></div>";
                
                // 본인 댓글일 경우 삭제 버튼 표시
                if(loginUser && loginUser === data[i].replyer) {
                    str += "    <button class='tc-btn tc-btn-danger tc-btn-sm removeReplyBtn' style='padding:2px 8px; font-size:11px;'>삭제</button>";
                }
                str += "  </div>";
                str += "  <div class='tc-reply-content'>" + data[i].reply + "</div>";
                str += "</li>";
            }
            replyUL.html(str);
        }).fail(function(xhr, status, err) {
            // 에러 시 처리 (백엔드 API가 아직 없으면 여기서 에러남)
            // console.log("댓글 로드 실패");
        });
    }

    // 댓글 등록
    $("#replyAddBtn").on("click", function() {
        var reply = $("#replyContent").val();
        
        if(reply.trim() == "") { alert("내용을 입력하세요"); return; }

        var replyObj = {
            reply: reply,
            replyer: loginUser,
            bno: bnoValue
        };

        $.ajax({
            type: 'post',
            url: '/replies/new',
            data: JSON.stringify(replyObj),
            contentType: "application/json; charset=utf-8",
            success: function(result) {
                if(result === "success") {
                    $("#replyContent").val(""); // 입력창 비우기
                    showList(1); // 목록 갱신
                }
            },
            error: function(e) {
                alert("댓글 등록 실패 (로그인 확인 필요)");
            }
        });
    });

    // 댓글 삭제 (이벤트 위임)
    replyUL.on("click", ".removeReplyBtn", function() {
        var rno = $(this).closest("li").data("rno");
        
        if(!confirm("삭제하시겠습니까?")) return;

        $.ajax({
            type: 'delete',
            url: '/replies/' + rno,
            success: function(result) {
                if(result === "success") {
                    showList(1);
                }
            },
            error: function(e) {
                alert("삭제 실패");
            }
        });
    });

    // 날짜 포맷팅 함수
    function displayTime(timeValue) {
        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if (gap < (1000 * 60 * 60 * 24)) {
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();
            return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
            var dd = dateObj.getDate();
            return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
        }
    }
});
</script>