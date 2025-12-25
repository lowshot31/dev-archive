<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy</title>
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <style>
        /* main-container 스타일 */
        .main-container {
            display: flex;
            flex-direction: column;
            padding: 20px;
            color: white;
        }

        .product:hover {
            transform: scale(1.03); /* hover 시 살짝 확대 */
        }

        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .product {
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

        .product:hover {
            transform: scale(1.03); /* hover 시 살짝 확대 */
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

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }


        .more-link {
            color: #d79672;
            text-decoration: none;
        }
    </style>
</head>
<body class="custom-scrollbar">
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <%@include file="include/category.jsp" %>
        <div class="main-container">
            <div class="section-header">
                <h2>최신 상품</h2>
                <a href="<c:url value="/prod/list?page=1"/>" class="more-link">더보기</a>
            </div>
            <div class="product-list">
                <c:forEach var="product" items="${productList}">
                    <div class="product">
                        <div class="product-image-container">
                                <%-- JSP EL 로 imageUrls (첫 번째 이미지 URL) 직접 접근 --%>
                            <c:choose>
                                <c:when test="${not empty product.imageUrls}">
                                    <img src="${product.imageUrls}" alt="Product Image" class="product-image"/>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/250x200?text=No+Image" alt="No Image"
                                         class="product-image"/>
                                    <%-- 대체 이미지 --%>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-details">
                            <div class="product-title">
                                <c:out value="${product.prodName}"/>
                            </div>
                            <div class="product-price">
                                $<c:out value="${product.price}"/>
                            </div>
                            <div class="product-description">
                                <c:out value="${product.prodDesc}"/>
                            </div>
                            <a href="<c:url value="http://localhost/prod/${product.prodId}"/>"
                               class="product-spec-button">상세보기</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</div>
</body>
</html>