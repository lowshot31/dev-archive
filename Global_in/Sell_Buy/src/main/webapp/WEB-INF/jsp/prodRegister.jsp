<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sell&Buy :: Product Register</title>

    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <script src="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.css"/>">
    <script src="<c:url value="/webjars/jquery-validation/1.20.0/jquery.validate.js"/>"></script>

    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <link rel="stylesheet" href="<c:url value="/style/prodRegister.css"/>">

    <script src="<c:url value="/script/prodRegister.js"/>"></script>
    <script src="<c:url value="/script/category.js"/>"></script>
    <script src="<c:url value="/script/prodRegisterValidator.js"/>"></script>

    <script>
        $(function () {
            loadCategories();
        });
    </script>
</head>
<body>
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <div class="main-container">
            <div class="content-left">
                <form id="prodRegisterForm" class="register-form">
                    <input type="hidden" id="category">
                    <label for="prodName">
                        <input type="text" id="prodName" name="prodName" placeholder="상품 이름" required>
                    </label>
                    <label for="price">
                        <input type="text" id="price" name="price" placeholder="상품 가격" required>
                    </label>
                    <div class="prodType">
                        <input type="checkbox" id="type_direct" name="trade_type" value="0">
                        <label for="type_direct">직거래</label>
                        <input type="checkbox" id="type_delivery" name="trade_type" value="1">
                        <label for="type_delivery">택배거래</label>
                    </div>
                    <label for="prodDesc">
                        <textarea id="prodDesc" name="prodDesc" placeholder="상품 설명" class="custom-scrollbar"
                                  required></textarea>
                    </label>
                    <button type="submit">등록하기</button>
                </form>
            </div>
            <div class="content-center">
                <div class="category-dep1 custom-scrollbar">
                    <ul id="category-dep1"></ul>
                </div>
                <div class="category-dep2 custom-scrollbar">
                    <ul id="category-dep2"></ul>
                </div>
                <div class="category-dep3 custom-scrollbar">
                    <ul id="category-dep3"></ul>
                </div>
            </div>

            <div class="content-right">
                <div class="image-container">
                    <!-- 큰 이미지 -->
                    <div id="big-preview" class="big-image"></div>

                    <!-- 작은 이미지 -->
                    <div class="small-images">
                        <!-- 이미지 1 -->
                        <div class="img-card">
                            <div class="img-insert" id="img1">
                                <input type="file" class="img-upload" onchange="uploadImage(this, 'img1')">
                                <input type="hidden" id="hidden-img1" name="image1">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img1')">보기</button>
                                <button class="delete-btn" onclick="deleteImage('img1')">삭제</button>
                            </div>
                        </div>

                        <!-- 이미지 2 -->
                        <div class="img-card">
                            <div class="img-insert" id="img2">
                                <input type="file" class="img-upload" onchange="uploadImage(this, 'img2')">
                                <input type="hidden" id="hidden-img2" name="image2">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img2')">보기</button>
                                <button class="delete-btn" onclick="deleteImage('img2')">삭제</button>
                            </div>
                        </div>

                        <!-- 이미지 3 -->
                        <div class="img-card">
                            <div class="img-insert" id="img3">
                                <input type="file" class="img-upload" onchange="uploadImage(this, 'img3')">
                                <input type="hidden" id="hidden-img3" name="image3">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img3')">보기</button>
                                <button class="delete-btn" onclick="deleteImage('img3')">삭제</button>
                            </div>
                        </div>

                        <!-- 이미지 4 -->
                        <div class="img-card">
                            <div class="img-insert" id="img4">
                                <input type="file" class="img-upload" onchange="uploadImage(this, 'img4')">
                                <input type="hidden" id="hidden-img4" name="image4">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img4')">보기</button>
                                <button class="delete-btn" onclick="deleteImage('img4')">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</div>

</body>
</html>
