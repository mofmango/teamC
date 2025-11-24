<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 수정</title>
</head>
<body>
    <h1>레시피 수정</h1>

    <form action="/recipe/modify" method="post" enctype="multipart/form-data">
        <input type="hidden" name="bno" value="${recipe.bno}">

        <div>
            <label>제목</label>
            <input type="text" name="title" value="<c:out value='${recipe.title}'/>">
        </div>

        <!-- ✅ 1인분 식비 -->
        <div>
            <label>1인분 식비 (원)</label>
            <input type="number" name="cost" min="0" value="${recipe.cost}" placeholder="예: 4500">
        </div>

        <!-- ✅ 소요시간 -->
        <div>
            <label>소요시간</label>
            <input type="text" name="time_required" value="${recipe.time_required}" placeholder="예: 15분 / 1시간">
        </div>

        <div>
            <label>기존 대표 사진</label>
            <div>
                <c:if test="${not empty recipe.image_path}">
                    <img src="${recipe.image_path}" alt="요리 사진" style="max-width: 200px;">
                </c:if>
                <input type="hidden" name="image_path" value="${recipe.image_path}">
            </div>
        </div>
        <div>
            <label>새 대표 사진</label>
            <input type="file" name="uploadFile">
        </div>
        <div>
            <label>태그</label>
            <input type="text" name="tags" placeholder="태그를 쉼표(,)로 구분하세요" value="${tagString}">
        </div>

        <div>
            <label>재료 (한 줄에 하나씩 입력하세요. 예: 닭가슴살 100g)</label><br>
            <textarea name="ingredients" rows="8" cols="50">${recipe.ingredients}</textarea>
        </div>
        <hr>

        <div id="steps-container">
            <c:forEach items="${recipe.steps}" var="step" varStatus="status">
                <div class="step-group">
                    <h4>Step ${step.step_order}</h4>
                    <input type="hidden" name="steps[${status.index}].step_order" value="${step.step_order}">
                    <div>
                        <label>설명</label>
                        <textarea name="steps[${status.index}].description" rows="3"><c:out value="${step.description}"/></textarea>
                    </div>
                    <div>
                        <label>사진</label>
                        <c:if test="${not empty step.image_path}">
                            <img src="${step.image_path}" alt="Step 사진" width="100">
                        </c:if>
                        <input type="file" name="stepImages">
                    </div>
                </div>
            </c:forEach>
        </div>

        <button type="button" id="add-step-btn">단계 추가</button>
        <hr>

        <button type="submit">수정 완료</button>
        <button type="button" onclick="location.href='/recipe/list'">목록으로</button>
    </form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    var stepCount = ${recipe.steps.size()};
    $('#add-step-btn').on('click', function() {
        stepCount++;
        var newStep = '<div class="step-group">' +
            '<h4>Step ' + stepCount + '</h4>' +
            '<input type="hidden" name="steps[' + (stepCount - 1) + '].step_order" value="' + stepCount + '">' +
            '<div><label>설명</label><textarea name="steps[' + (stepCount - 1) + '].description" rows="3"></textarea></div>' +
            '<div><label>사진</label><input type="file" name="stepImages"></div>' +
            '</div>';
        $('#steps-container').append(newStep);
    });
});
</script>
</body>
</html>