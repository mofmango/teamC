<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    [스타일 정의] 
    상세 페이지(get.jsp)와 동일한 레이아웃 규칙을 적용하여 통일감을 줍니다.
--%>
<style>
    /* 1. Body는 전체 너비 사용 */
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
        margin: 40px auto; /* 상하 40px, 좌우 자동 */
        padding: 0 20px;
        box-sizing: border-box;
    }

    /* 3. 단계(Step) 박스 스타일 강화 */
    .tc-detail-box {
        background: #1b1d22;
        border: 1px solid #2b2f37;
        border-radius: 16px;
        padding: 24px;
        margin-bottom: 20px;
    }
</style>

<c:set var="extraCss" value="recipe.css"/>
<c:set var="pageTitle" value="레시피 등록"/>
<c:set var="bodyClass" value="tc-main-page"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title">레시피 등록</h1>
        <p class="tc-page-sub">나만의 특별한 레시피를 공유해 주세요.</p>
    </div>

    <div id="warning-box" style="display: none; margin-bottom: 20px; padding: 15px; background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); border-radius: 8px; color: var(--danger); font-weight: 600; font-size: 14px;">
        ⚠️ 제목, 대표 사진, 태그, 첫 번째 단계 설명은 필수 항목입니다.
    </div>

    <div class="tc-form-card" style="background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 32px;">
        <form action="/recipe/register" method="post" enctype="multipart/form-data" class="tc-form">
            
            <div class="tc-form-row">
                <label class="tc-form-label">제목 <span style="color:var(--accent)">*</span></label>
                <input type="text" name="title" id="title-input" class="tc-form-input" placeholder="레시피 제목을 입력하세요">
            </div>

            <div class="tc-form-row inline">
                <div class="tc-form-field">
                    <label class="tc-form-label">1인분 식비 (원)</label>
                    <input type="number" name="cost" min="0" class="tc-form-input" placeholder="예: 4500">
                </div>
                <div class="tc-form-field">
                    <label class="tc-form-label">소요시간</label>
                    <input type="text" name="time_required" class="tc-form-input" placeholder="예: 15분 / 1시간">
                </div>
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">대표 사진 <span style="color:var(--accent)">*</span></label>
                <div class="tc-form-file">
                    <input type="file" name="uploadFile" id="main-file-input">
                </div>
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">태그 <span style="color:var(--accent)">*</span></label>
                <input type="text" name="tags" id="tags-input" class="tc-form-input" placeholder="태그를 쉼표(,)로 구분하세요 (예: 간단,자취,안주)">
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">재료</label>
                <p class="tc-form-help">한 줄에 하나씩 입력하세요. (예: 닭가슴살 100g)</p>
                <textarea name="ingredients" rows="8" class="tc-form-textarea" placeholder="재료를 입력하세요"></textarea>
            </div>

            <hr style="border-color: var(--border); margin: 30px 0;">

            <h3 class="tc-page-title" style="font-size: 20px; margin-bottom: 20px;">조리 과정</h3>

            <div id="steps-container">
                <div class="step-group tc-detail-box">
                    <h4 class="tc-detail-box-title" style="font-size:16px; margin-bottom:12px; color:#fff;">Step 1 <span style="color:var(--accent)">*</span></h4>
                    <input type="hidden" name="steps[0].step_order" value="1">
                    
                    <div class="tc-form-row">
                        <label class="tc-form-label">설명</label>
                        <textarea name="steps[0].description" rows="3" id="step1-desc-input" class="tc-form-textarea" placeholder="자세한 설명을 적어주세요."></textarea>
                    </div>
                    
                    <div class="tc-form-row" style="margin-top:12px;">
                        <label class="tc-form-label">사진</label>
                        <div class="tc-form-file">
                            <input type="file" name="stepImages">
                        </div>
                    </div>
                </div>
            </div>

            <div style="margin-top: 20px; text-align: center;">
                <button type="button" id="add-step-btn" class="tc-btn tc-btn-outline" style="width:100%; border-style:dashed;">+ 단계 추가</button>
            </div>
            
            <hr style="border-color: var(--border); margin: 30px 0 20px;">

            <div class="tc-form-actions">
                <button type="button" class="tc-btn tc-btn-outline" onclick="location.href='/recipe/list'">취소</button>
                <button type="submit" id="register-btn" class="tc-btn tc-btn-primary">등록하기</button>
            </div>
        </form>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    var stepCount = 1;

    // ★ 디자인이 적용된 새 Step HTML 추가
    $('#add-step-btn').on('click', function() {
        stepCount++;
        var newStep = 
            '<div class="step-group tc-detail-box">' +
                '<h4 class="tc-detail-box-title" style="font-size:16px; margin-bottom:12px; color:#fff;">Step ' + stepCount + '</h4>' +
                '<input type="hidden" name="steps[' + (stepCount - 1) + '].step_order" value="' + stepCount + '">' +
                '<div class="tc-form-row">' +
                    '<label class="tc-form-label">설명</label>' +
                    '<textarea name="steps[' + (stepCount - 1) + '].description" rows="3" class="tc-form-textarea" placeholder="설명을 입력하세요."></textarea>' +
                '</div>' +
                '<div class="tc-form-row" style="margin-top:12px;">' +
                    '<label class="tc-form-label">사진</label>' +
                    '<div class="tc-form-file"><input type="file" name="stepImages"></div>' +
                '</div>' +
            '</div>';
        $('#steps-container').append(newStep);
    });

    // 기존 유효성 검사 로직 유지
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