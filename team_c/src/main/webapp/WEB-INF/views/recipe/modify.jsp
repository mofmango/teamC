<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    [스타일 정의] 
    상세/등록 페이지와 동일한 중앙 정렬 레이아웃 적용
--%>
<style>
    /* 1. Body는 전체 너비 사용 */
    body.tc-main-page {
        display: block !important;
        width: 100% !important;
        margin: 0 !important;
        background-color: #141518 !important;
    }

    /* 2. 본문 영역 중앙 정렬 */
    .tc-page-section {
        width: 100%;
        max-width: 1080px; 
        margin: 40px auto; 
        padding: 0 20px;
        box-sizing: border-box;
    }

    /* 3. 단계(Step) 박스 스타일 */
    .tc-detail-box {
        background: #1b1d22;
        border: 1px solid #2b2f37;
        border-radius: 16px;
        padding: 24px;
        margin-bottom: 20px;
    }
</style>

<%-- recipe.css 적용 --%>
<c:set var="extraCss" value="recipe.css"/>
<c:set var="pageTitle" value="레시피 수정"/>
<c:set var="bodyClass" value="tc-main-page"/>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<section class="tc-page-section">
    <div class="tc-page-head">
        <h1 class="tc-page-title">레시피 수정</h1>
        <p class="tc-page-sub">등록된 내용을 수정합니다.</p>
    </div>

    <div class="tc-form-card" style="background: #1b1d22; border: 1px solid #2b2f37; border-radius: 16px; padding: 32px;">
        <form action="/recipe/modify" method="post" enctype="multipart/form-data" class="tc-form">
            <input type="hidden" name="bno" value="${recipe.bno}">

            <div class="tc-form-row">
                <label class="tc-form-label">제목</label>
                <input type="text" name="title" value="<c:out value='${recipe.title}'/>" class="tc-form-input">
            </div>

            <div class="tc-form-row inline">
                <div class="tc-form-field">
                    <label class="tc-form-label">1인분 식비 (원)</label>
                    <input type="number" name="cost" min="0" value="${recipe.cost}" class="tc-form-input" placeholder="예: 4500">
                </div>
                <div class="tc-form-field">
                    <label class="tc-form-label">소요시간</label>
                    <input type="text" name="time_required" value="${recipe.time_required}" class="tc-form-input" placeholder="예: 15분 / 1시간">
                </div>
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">대표 사진</label>
                
                <div style="padding: 16px; background: var(--panel-2); border-radius: 10px; border: 1px solid var(--border);">
                    <c:if test="${not empty recipe.image_path}">
                        <div style="margin-bottom: 12px;">
                            <span class="tc-form-help" style="display:block; margin-bottom:6px;">현재 사진:</span>
                            <img src="${recipe.image_path}" alt="요리 사진" style="max-width: 200px; border-radius: 8px; border:1px solid var(--border);">
                        </div>
                    </c:if>
                    <input type="hidden" name="image_path" value="${recipe.image_path}">
                    
                    <label class="tc-form-label" style="display:block; margin-top:10px;">사진 변경 (파일 선택 시 덮어쓰기)</label>
                    <div class="tc-form-file">
                        <input type="file" name="uploadFile">
                    </div>
                </div>
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">태그</label>
                <input type="text" name="tags" value="${tagString}" class="tc-form-input" placeholder="태그를 쉼표(,)로 구분하세요">
            </div>

            <div class="tc-form-row">
                <label class="tc-form-label">재료</label>
                <p class="tc-form-help">한 줄에 하나씩 입력해 주세요.</p>
                <textarea name="ingredients" rows="8" class="tc-form-textarea">${recipe.ingredients}</textarea>
            </div>

            <hr style="border-color: var(--border); margin: 30px 0;">

            <h3 class="tc-page-title" style="font-size: 20px; margin-bottom: 20px;">조리 과정 수정</h3>

            <div id="steps-container">
                <c:forEach items="${recipe.steps}" var="step" varStatus="status">
                    <div class="step-group tc-detail-box">
                        <h4 class="tc-detail-box-title" style="font-size:16px; margin-bottom:12px; color:#fff;">Step ${step.step_order}</h4>
                        <input type="hidden" name="steps[${status.index}].step_order" value="${step.step_order}">
                        
                        <div class="tc-form-row">
                            <label class="tc-form-label">설명</label>
                            <textarea name="steps[${status.index}].description" rows="3" class="tc-form-textarea"><c:out value="${step.description}"/></textarea>
                        </div>
                        
                        <div class="tc-form-row" style="margin-top: 12px;">
                            <label class="tc-form-label">사진</label>
                            <div style="padding: 10px; background: var(--panel-2); border-radius: 8px; border: 1px solid var(--border);">
                                <c:if test="${not empty step.image_path}">
                                    <div style="margin-bottom: 8px;">
                                        <img src="${step.image_path}" alt="Step 사진" style="max-width: 100px; border-radius: 4px;">
                                        <span class="tc-form-help"> (현재 사진)</span>
                                    </div>
                                </c:if>
                                <div class="tc-form-file">
                                    <input type="file" name="stepImages">
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div style="margin-top: 20px; text-align: center;">
                <button type="button" id="add-step-btn" class="tc-btn tc-btn-outline" style="width:100%; border-style:dashed;">+ 단계 추가</button>
            </div>
            
            <hr style="border-color: var(--border); margin: 30px 0 20px;">

            <div class="tc-form-actions">
                <button type="button" class="tc-btn tc-btn-outline" onclick="location.href='/recipe/list'">취소</button>
                <button type="submit" class="tc-btn tc-btn-primary">수정 완료</button>
            </div>
        </form>
    </div>
</section>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    var stepCount = ${recipe.steps.size()};

    // ★ 디자인이 적용된 새 Step 추가
    $('#add-step-btn').on('click', function() {
        stepCount++;
        var newStep = 
            '<div class="step-group tc-detail-box">' +
                '<h4 class="tc-detail-box-title" style="font-size:16px; margin-bottom:12px; color:#fff;">Step ' + stepCount + '</h4>' +
                '<input type="hidden" name="steps[' + (stepCount - 1) + '].step_order" value="' + stepCount + '">' +
                '<div class="tc-form-row">' +
                    '<label class="tc-form-label">설명</label>' +
                    '<textarea name="steps[' + (stepCount - 1) + '].description" rows="3" class="tc-form-textarea"></textarea>' +
                '</div>' +
                '<div class="tc-form-row" style="margin-top: 12px;">' +
                    '<label class="tc-form-label">사진</label>' +
                    '<div class="tc-form-file"><input type="file" name="stepImages"></div>' +
                '</div>' +
            '</div>';
        $('#steps-container').append(newStep);
    });
});
</script>