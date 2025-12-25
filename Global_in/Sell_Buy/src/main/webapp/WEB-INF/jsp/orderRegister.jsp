<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy</title>
    <script async src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <style>
        .form-group {
            display: flex;
            align-items: flex-start; /* 세로 정렬을 위쪽으로 */
            gap: 10px; /* 요소들 사이 간격 */
            color: white;
            padding: 1%;
        }

        .form-group label {
            min-width: 100px; /* 라벨의 최소 너비 설정 */
            text-align: left; /* 라벨 텍스트 왼쪽 정렬 */
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
            flex: 1; /* 남은 공간을 모두 차지 */
            max-width: 400px; /* 최대 너비 제한 */
        }

        .form-group #description {
            height: 100px; /* textarea 높이 설정 */
        }

        /* 라디오 버튼 그룹을 위한 스타일 */
        .form-group .radio-group {
            display: flex;
            gap: 20px;
            align-items: center;
        }


    </style>
    <script>

    </script>
</head>
<body>
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="main-container">
        <div class="content">
            <form id="prodRegForm">
                <h1 style="color: white">상품등록 페이지</h1>
                <hr/>
                <div class="form-group">
                    <label for="name">상품명</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label id="trade_code">거래 종류</label>
                    <input type="radio" id="select" name="shop" value=0><label for="trade_code">직거래</label>
                    <input type="radio" id="select2" name="shop" value=1><label for="trade_code">택배</label>
                </div>
                <div class="form-group">
                    <label for="price">가격</label>
                    <input type="text" id="price" name="price" required pattern="[0-9]+" inputmode="numeric">
                </div>
                <div class="form-group">
                    <label for="description">상품 설명</label>
                    <textarea id="description" name="description" required></textarea>
                </div>
                <div class="form-group">
                    <label for="category">카테고리</label>
                    <select id="category" style="width: 15%">
                        <optgroup label="--"></optgroup>
                    </select>
                </div>
                <div class="form-group">
                    <label for="image">상품 이미지</label>
                    <input type="file" id="image" name="image" accept=".jpg,.jpeg,.png" required>
                </div>
                <button type="submit">등록</button>
            </form>
        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</body>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const header_search = document.querySelector('.header-search');
        const category = document.querySelector('#category');
        let isAdded = false;
        header_search.style.display = 'none';
        //카테고리 클릭시 컨트롤러에서 json타입으로 값 리턴한거 계층 구조로 표시
        category.addEventListener('click', function () {
            if (!isAdded) {
                const options = [
                    new Option("category_name", "category_id"),
                    new Option("category_name", "category_id"),
                    new Option("category_name", "category_id"),
                    new Option("category_name", "category_id"),
                ]
                isAdded = true
                options.forEach(option => {
                    this.add(option);
                })

            }
        })
        // 가격입력
        document.getElementById('price').addEventListener('input', function () {
            if (isNaN(this.value)) {
                alert('숫자만 입력 가능합니다.');
                this.value = this.value.replace(/[^0-9]/g, '');
            }
        });
    });

</script>
</html>