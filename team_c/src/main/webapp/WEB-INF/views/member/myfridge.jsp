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

    <!-- 재료 추가 영역 -->
    <div>
        <h4>재료 추가</h4>
        <input type="text" id="ingredient-name" placeholder="재료 이름을 입력하세요">
        <button id="add-btn">추가</button>
    </div>

    <hr>

    <!-- 보유 재료 목록 -->
    <h4>보유 재료 목록</h4>
    <ul id="ingredient-list">
        <!-- AJAX로 동적으로 채워짐 -->
    </ul>

    <hr>
    <%-- 추천 레시피 영역은 나중에 살릴 거면 여기 사용
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
    --%>

    <br>
    <button onclick="location.href='/member/mypage'">마이페이지로</button>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
    $(document).ready(function() {

        // 재료 목록 불러오기
        function loadIngredients() {
            $.ajax({
                type: 'GET',
                url: '/ingredients/list',
                success: function(list) {
                    var str = "";
                    if (list && list.length > 0) {
                        for (var i = 0; i < list.length; i++) {
                            var name = list[i];
                            str += "<li>" 
                                + name 
                                + " <button class='remove-btn' data-name='" 
                                + name 
                                + "'>삭제</button></li>";
                        }
                    } else {
                        str = "<li>등록된 재료가 없습니다.</li>";
                    }
                    $("#ingredient-list").html(str);
                },
                error: function(xhr) {
                    if (xhr.status == 401) {
                        alert("로그인이 필요합니다.");
                    } else {
                        alert("재료 목록을 불러오지 못했습니다.");
                    }
                }
            });
        }

        // 페이지 로딩 시 최초 1회 호출
        loadIngredients();

        // 재료 추가
        $("#add-btn").on("click", function() {
            var ingredientName = $("#ingredient-name").val();

            if (!ingredientName || ingredientName.trim() === '') {
                alert("재료 이름을 입력하세요.");
                return;
            }

            var trimmed = ingredientName.trim();
            // 한글/공백 대비해서 URL 인코딩
            var encodedName = encodeURIComponent(trimmed);

            $.ajax({
                type: 'POST',
                url: '/ingredients/' + encodedName,
                success: function(result) {
                    if (result === 'success') {
                        $("#ingredient-name").val("");
                        loadIngredients();
                    }
                },
                error: function(xhr) {
                    if (xhr.status == 401) {
                        alert("로그인이 필요합니다.");
                    } else {
                        alert("등록에 실패했습니다.");
                    }
                }
            });
        });

        // 엔터키로도 추가 가능
        $("#ingredient-name").on("keypress", function(e) {
            if (e.which === 13) {
                $("#add-btn").click();
            }
        });

        // 재료 삭제 (동적 바인딩)
        $("#ingredient-list").on("click", ".remove-btn", function() {
            var ingredientName = $(this).data("name");

            if (!confirm("'" + ingredientName + "' 재료를 삭제하시겠습니까?")) {
                return;
            }

            // 삭제 호출 시에도 인코딩
            var encodedName = encodeURIComponent(ingredientName);

            $.ajax({
                type: 'DELETE',
                url: '/ingredients/' + encodedName,
                success: function(result) {
                    if (result === 'success') {
                        loadIngredients();
                    }
                },
                error: function(xhr) {
                    if (xhr.status == 401) {
                        alert("로그인이 필요합니다.");
                    } else {
                        alert("삭제에 실패했습니다.");
                    }
                }
            });
        });

    });
    </script>
</body>
</html>