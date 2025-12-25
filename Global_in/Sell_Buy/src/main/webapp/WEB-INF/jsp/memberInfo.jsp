<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy :: 내 정보</title>
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <style>
        .main-container {
            display: flex;
            flex-direction: column;
            padding: 20px;
            color: white;
        }

        .member-info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .member-info-table th, .member-info-table td {
            border: 1px solid #444;
            padding: 8px;
            text-align: left;
        }

        .member-info-table th {
            background-color: #332831;
            color: white;
            width: 150px;
        }

        .section-title {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 15px;

        }

        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .product-card {
            border: 1px solid #444;
            border-radius: 8px;
            padding: 15px;
            background-color: #332831;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.2s ease-in-out;
            position: relative; /* 버튼 위치 고정을 위해 추가 */
        }

        .product-image-container {
            text-align: center;
            margin-bottom: 10px;
            width: 100%;
            height: 200px;
            overflow: hidden;
        }

        .product-image {
            max-width: 100%;
            height: 100%;
            border-radius: 8px;
            width: 100%;
            object-fit: cover;
            object-position: center;
        }

        .product-details {
            flex-grow: 1;
        }

        .product-title {
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap; /* 한 줄로 표시 */
        }

        .product-price {
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .product-description {
            color: #ddd;
            font-size: 0.9em;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            margin-bottom: 35px; /* 버튼 위치를 위해 여백 추가 */
        }

        .product-list-empty {
            text-align: center;
            color: #ddd;
            padding: 20px;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .update-button {
            padding: 10px 20px;
            background-color: #d79672;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        .more-link {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #d79672;
            text-decoration: none;
        }

        .product-spec-button {
            display: inline-block;
            padding: 8px 15px;
            background-color: #d79672;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            text-align: center;
            position: absolute; /* 버튼 위치 고정을 위해 추가 */
            bottom: 10px; /* 버튼 위치 고정을 위해 추가 */
            left: 50%; /* 버튼 위치 고정을 위해 추가 */
            transform: translateX(-50%); /* 버튼 위치 고정을 위해 추가 */
        }

        .product-spec-button:hover {
            background-color: #b07860;
        }

        .product-card:hover {
            transform: scale(1.03);
            /* hover 시 살짝 확대 */
        }
    </style>
    <script>

    </script>
</head>
<body class="custom-scrollbar">
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <%@include file="include/category.jsp" %>
        <div class="main-container">
            <h2>내 정보</h2>

            <table class="member-info-table">
                <tr>
                    <th>아이디</th>
                    <td><c:out value="${member.loginId}"/></td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td><c:out value="${member.nickname}"/></td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><c:out value="${member.name}"/></td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td><c:out value="${member.email}"/></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><c:out value="${member.phoneNum}"/></td>
                </tr>
                <tr>
                    <th>가입일시</th>
                    <td><c:out value="${member.createDate}"/></td>
                </tr>
            </table>

            <h3 class="section-title">찜한 상품</h3>
            <div id="fav-list" class="product-list">
                <script>
                    // 받아온 찜 목록 리스트 표시
                    <c:forEach var="product" items="${favoriteProductList}">
                    $('#fav-list').append(`
                        <div class="product-card">
                            <div class="product-image-container">
                                <img src="${product.listImageUrls[0]}" alt="Product Image" class="product-image"/>
                            </div>
                            <div class="product-details">
                                <div class="product-title">${product.prodName}</div>
                                <div class="product-price">$${product.price}</div>
                                <div class="product-description">${product.prodDesc}</div>
                                <a href="http://localhost/prod/${product.prodId}" class="product-spec-button">상세보기</a>
                            </div>
                        </div>
                        `);
                    </c:forEach>
                </script>
            </div>
            <a href="<c:url value="/fav/list?page=1&size=99999"/>" class="more-link">찜 목록 더보기</a>

            <h3 class="section-title">판매 상품</h3>
            <div id="sell-list" class="product-list">
                <script>
                    // 받아온 판매 상품 리스트 표시
                    <c:forEach var="product" items="${sellProductList}">
                    $('#sell-list').append(`
                        <div class="product-card">
                            <div class="product-image-container">
                                <img src="${product.listImageUrls[0]}" alt="Product Image" class="product-image"/>
                            </div>
                            <div class="product-details">
                                <div class="product-title">${product.prodName}</div>
                                <div class="product-price">$${product.price}</div>
                                <div class="product-description">${product.prodDesc}</div>
                                <a href="http://localhost/prod/${product.prodId}" class="product-spec-button">상세보기</a>
                            </div>
                        </div>
                        `);
                    </c:forEach>
                </script>
            </div>
            <a href="<c:url value="/prod/list?page=1&size=99999&searchType=seller&searchQuery=${member.nickname}"/>"
               class="more-link">판매 상품 더보기</a>


            <div class="button-container">
                <button class="update-button" onclick="location.href='<c:url value="/member/update"/>'">회원 정보 수정
                </button>
            </div>
        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</div>
</body>
</html>
