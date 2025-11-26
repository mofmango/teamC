<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 스타일 적용 --%>
<style>
    body.tc-main-page { display: block !important; width: 100% !important; margin: 0 !important; background-color: #141518 !important; }
    .tc-page-section { width: 100%; max-width: 800px; margin: 40px auto; padding: 0 20px; box-sizing: border-box; }
    
    .tc-card { background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 30px; margin-bottom: 20px; }
    
    .tc-input { background: #252830; border: 1px solid #2b2f37; border-radius: 8px; padding: 10px 14px; color: #e8eaf0; width: 100%; box-sizing: border-box; }
    .tc-input:focus { border-color: #3b82f6; outline: none; }
    
    .tc-btn { padding: 10px 20px; border-radius: 8px; border: none; font-weight: 600; cursor: pointer; color: white; }
    .tc-btn-primary { background: #3b82f6; }
    .tc-btn-danger { background: #ef4444; font-size: 12px; padding: 4px 10px; }
    
	.tc-fridge-add-btn {min-width: 72px; height: 44px; padding: 0 18px; border-radius: 999px; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 600; background: #f9fafb; color: #111827; border: none;}
    
    #ingredient-list { list-style: none; padding: 0; display: flex; flex-wrap: wrap; gap: 10px; }
    #ingredient-list li { background: #252830; color: #e8eaf0; padding: 8px 16px; border-radius: 20px; display: flex; align-items: center; gap: 10px; border: 1px solid #2b2f37; }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="bodyClass" value="tc-main-page"/>
<c:set var="pageTitle" value="나의 냉장고"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 style="font-size:26px; color:white; margin-bottom:8px;">나의 냉장고</h1>
        <p style="color:#9ca3af;">보유한 식재료를 관리하고 맞춤 레시피를 확인하세요.</p>
    </div>

    <div class="tc-card">
        <h4 style="color:white; margin:0 0 12px 0;">재료 추가</h4>
        <div style="display:flex; gap:10px;">
            <input type="text" id="ingredient-name" class="tc-input" placeholder="재료 이름 (예: 계란)">
			<button id="add-btn" class="tc-btn tc-fridge-add-btn">추가</button>
        </div>
    </div>

    <div class="tc-card">
        <h4 style="color:white; margin:0 0 16px 0;">보유 재료 목록</h4>
        <ul id="ingredient-list">
            </ul>
    </div>

    <div style="text-align: center; margin-top: 30px;">
        <button class="tc-btn" style="background:transparent; color:#9ca3af;" onclick="location.href='/member/mypage'">마이페이지로</button>
    </div>
</section>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    function loadIngredients() {
        $.ajax({
            type: 'GET', url: '/ingredients/list',
            success: function(list) {
                var str = "";
                if (list && list.length > 0) {
                    for (var i = 0; i < list.length; i++) {
                        var name = list[i];
                        str += "<li>" + name + " <button class='tc-btn tc-btn-danger remove-btn' data-name='" + name + "'>×</button></li>";
                    }
                } else {
                    str = "<li style='background:none; border:none; color:#9ca3af;'>등록된 재료가 없습니다.</li>";
                }
                $("#ingredient-list").html(str);
            },
            error: function(xhr) {
                if (xhr.status == 401) alert("로그인이 필요합니다.");
            }
        });
    }

    loadIngredients();

    $("#add-btn").on("click", function() {
        var ingredientName = $("#ingredient-name").val();
        if (!ingredientName || ingredientName.trim() === '') { alert("재료 이름을 입력하세요."); return; }
        var encodedName = encodeURIComponent(ingredientName.trim());

        $.ajax({
            type: 'POST', url: '/ingredients/' + encodedName,
            success: function(result) {
                if (result === 'success') { $("#ingredient-name").val(""); loadIngredients(); }
            },
            error: function(xhr) {
                if (xhr.status == 401) alert("로그인이 필요합니다.");
                else alert("등록 실패");
            }
        });
    });

    $("#ingredient-name").on("keypress", function(e) { if (e.which === 13) $("#add-btn").click(); });

    $("#ingredient-list").on("click", ".remove-btn", function() {
        var ingredientName = $(this).data("name");
        if (!confirm("'" + ingredientName + "' 삭제하시겠습니까?")) return;
        var encodedName = encodeURIComponent(ingredientName);

        $.ajax({
            type: 'DELETE', url: '/ingredients/' + encodedName,
            success: function(result) { if (result === 'success') loadIngredients(); },
            error: function() { alert("삭제 실패"); }
        });
    });
});
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>