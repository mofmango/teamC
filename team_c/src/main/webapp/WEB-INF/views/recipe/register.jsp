<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 등록</title>
</head>
<body>
    <h1>레시피 등록</h1>

    <div id="warning-box" style="color: red; font-weight: bold; display: none;">
        <p>제목, 대표 사진, 태그, 첫 번째 단계 설명은 필수 항목입니다.</p>
    </div>

    <form action="/recipe/register" method="post" enctype="multipart/form-data">
        <div>
            <label>제목</label>
            <input type="text" name="title" id="title-input">
        </div>
        <div>
            <label>대표 사진</label>
            <input type="file" name="uploadFile" id="main-file-input">
        </div>
        <div>
            <label>태그</label>
            <input type="text" name="tags" id="tags-input" placeholder="태그를 쉼표(,)로 구분하세요">
        </div>
        <div>
            <label>재료 (한 줄에 하나씩 입력하세요. 예: 닭가슴살 100g)</label><br>
            <textarea name="ingredients" rows="8" cols="50"></textarea>
        </div>
        
        <hr>

        <div id="steps-container">
            <div class="step-group">
                <h4>Step 1</h4>
                <input type="hidden" name="steps[0].step_order" value="1">
                <div>
                    <label>설명</label>
                    <textarea name="steps[0].description" rows="3" id="step1-desc-input"></textarea>
                </div>
                <div>
                    <label>사진</label>
                    <input type="file" name="stepImages">
                </div>
            </div>
        </div>

        <button type="button" id="add-step-btn">단계 추가</button>
        <hr>

        <button type="submit" id="register-btn">등록</button>
        <button type="button" onclick="location.href='/recipe/list'">목록으로</button>
    </form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    var stepCount = 1;
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

    var titleInput = $('#title-input');
    var mainFileInput = $('#main-file-input');
    var tagsInput = $('#tags-input');
    var step1DescInput = $('#step1-desc-input');
    var registerBtn = $('#register-btn');
    var warningBox = $('#warning-box');

    function checkFormState() {
        var titleVal = titleInput.val();
        var mainFileVal = mainFileInput.val();
        var tagsVal = tagsInput.val();
        var step1DescVal = step1DescInput.val();
        
        if (titleVal.trim() !== '' && mainFileVal && tagsVal.trim() !== '' && step1DescVal.trim() !== '') {
            registerBtn.prop('disabled', false); 
            warningBox.hide();
        } else {
            registerBtn.prop('disabled', true);
            warningBox.show();
        }
    }

    checkFormState();

    $('#title-input, #main-file-input, #tags-input, #step1-desc-input').on('keyup change', checkFormState);
});
</script>
</body>
</html>