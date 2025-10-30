<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 냉장고</title>
</head>
<body>
    <h1>나의 냉장고</h1>
    <p>현재 보유한 식재료를 관리하고, 추천 레시피를 확인하세요.</p>
    <hr>

    <div>
        <h4>재료 추가</h4>
        <input type="text" id="ingredient-name" placeholder="재료 이름을 입력하세요">
        <button id="add-btn">추가</button>
    </div>

    <hr>

    <h4>보유 재료 목록</h4>
    <ul id="ingredient-list">
    </ul>

	<hr>
    <h3>추천 레시피</h3>
    <table border="1" style="width: 100%; text-align: center;">
        <thead>
            <tr>
                <th>일치율</th>
                <th>이미지</th>
                <th>제목</th>
                <th>작성자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${recommendList}" var="recipe">
                <tr>
                    <td>${recipe.match_count}개 재료 일치</td>
                    <td>
                        <c:if test="${not empty recipe.image_path}">
                            <img src="${recipe.image_path}" alt="요리 사진" width="100">
                        </c:if>
                    </td>
                    <td>
                        <a href="/recipe/get?bno=${recipe.bno}">
                            <c:out value="${recipe.title}"/>
                        </a>
                    </td>
                    <td><c:out value="${recipe.writerName}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>


    <br>
    <button onclick="location.href='/member/mypage'">마이페이지로</button>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {

    function loadIngredients() {
        $.ajax({
            type: 'get',
            url: '/ingredients/list',
            success: function(list) {
                var str = "";
                if (list && list.length > 0) {
                    for (var i = 0; i < list.length; i++) {
                        str += "<li>" + list[i] + " <button class='remove-btn' data-name='" + list[i] + "'>삭제</button></li>";
                    }
                } else {
                    str = "<li>등록된 재료가 없습니다.</li>";
                }
                $("#ingredient-list").html(str);
            }
        });
    }

    loadIngredients();

    $("#add-btn").on("click", function() {
        var ingredientName = $("#ingredient-name").val();
        if (!ingredientName || ingredientName.trim() === '') {
            alert("재료 이름을 입력하세요.");
            return;
        }

        $.ajax({
            type: 'post',
            url: '/ingredients/' + ingredientName,
            success: function(result) {
                if (result === 'success') {
                    $("#ingredient-name").val("");
                    loadIngredients();
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); }
                else { alert("등록에 실패했습니다."); }
            }
        });
    });

   
    $("#ingredient-list").on("click", ".remove-btn", function() {
        var ingredientName = $(this).data("name");

        $.ajax({
            type: 'delete',
            url: '/ingredients/' + ingredientName,
            success: function(result) {
                if (result === 'success') {
                    loadIngredients();
                }
            },
            error: function(xhr) {
                if(xhr.status == 401) { alert("로그인이 필요합니다."); }
                else { alert("삭제에 실패했습니다."); }
            }
        });
    });
});
</script>
</body>
</html>