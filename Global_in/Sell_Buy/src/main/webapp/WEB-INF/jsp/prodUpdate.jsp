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

    <script src="<c:url value="/script/prodRegisterValidator.js"/>"></script>
    <script src="<c:url value="/script/prodRegister.js"/>"></script>
    <script src="<c:url value="/script/category.js"/>"></script>

    <script>
        let dep1;
        let dep2;
        $(window).on('load', function () {
            let categoryIds = ${categoryIds};

            loadCategories();
            loadCategories(categoryIds[0]);
            loadCategories(categoryIds[1]);

            setTimeout(function () {
                $('.category-dep1 li').each(function () {
                    if ($(this).attr('catid') == categoryIds[0]) {
                        $(this).addClass('selected');
                    }
                });

                $('.category-dep2 li').each(function () {
                    if ($(this).attr('catid') == categoryIds[1]) {
                        $(this).addClass('selected');
                    }
                });

                $('.category-dep3 li').each(function () {
                    if ($(this).attr('catid') == categoryIds[2]) {
                        $(this).addClass('selected');
                    }
                });

                $('#category').val(categoryIds[2]);
            }, 1000);
            console.log(categoryIds[2]);
        });
        $(function () {

            let prodType = ${product.prodType};
            if (prodType === 0) {
                $('#type_direct').prop('checked', true);
            } else if (prodType === 1) {
                $('#type_delivery').prop('checked', true);
            } else {
                $('#type_direct').prop('checked', true);
                $('#type_delivery').prop('checked', true);
            }
            console.log(${categoryIds});
        });


    </script>
</head>
<body>
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <div class="main-container">
            <div class="content-left">
                <form id="prodUpdateForm" class="update-form">
                    <input type="hidden" id="category">
                    <label for="prodName">
                        <input type="text" id="prodName" name="prodName" placeholder="상품 이름" required
                               value="${product.prodName}">
                    </label>
                    <label for="price">
                        <input type="text" id="price" name="price" placeholder="상품 가격" required
                               value="${product.price}">
                    </label>
                    <div class="prodType">
                        <input type="checkbox" id="type_direct" name="trade_type" value="0">
                        <label for="type_direct">직거래</label>
                        <input type="checkbox" id="type_delivery" name="trade_type" value="1">
                        <label for="type_delivery">택배거래</label>
                    </div>
                    <label for="prodDesc">
                        <textarea id="prodDesc" name="prodDesc" placeholder="상품 설명" class="custom-scrollbar"
                                  required>${product.prodDesc}</textarea>
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
                    <div id="big-preview" class="big-image" style="background-image: url(${imageUrls[0]})"></div>

                    <!-- 작은 이미지 -->
                    <div class="small-images">
                        <!-- 이미지 1 -->
                        <div class="img-card">
                            <div class="img-insert" id="img1" style="background-image: url(${imageUrls[0]})">
                                <input type="hidden" id="hidden-img1" name="image1">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img1')">보기</button>
                            </div>
                        </div>

                        <!-- 이미지 2 -->
                        <div class="img-card">
                            <div class="img-insert" id="img2" style="background-image: url(${imageUrls[1]})">
                                <input type="hidden" id="hidden-img2" name="image2">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img2')">보기</button>
                            </div>
                        </div>

                        <!-- 이미지 3 -->
                        <div class="img-card">
                            <div class="img-insert" id="img3" style="background-image: url(${imageUrls[2]})">
                                <input type="hidden" id="hidden-img3" name="image3">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img3')">보기</button>
                            </div>
                        </div>

                        <!-- 이미지 4 -->
                        <div class="img-card">
                            <div class="img-insert" id="img4" style="background-image: url(${imageUrls[3]})">
                                <input type="hidden" id="hidden-img4" name="image4">
                            </div>
                            <div class="img-controls">
                                <button class="view-btn" onclick="viewImage('img4')">보기</button>
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
