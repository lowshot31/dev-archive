<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy :: 상품 목록</title>
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <style>
        .main-container {
            display: flex;
            flex-direction: column;
            padding: 20px;
            color: white;
        }

        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px; /* "더보기" 링크 위한 여백 추가 */
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

        .loading-spinner {
            text-align: center;
            padding: 20px;
        }

        .loading-spinner.hidden {
            display: none; /* hidden 클래스 추가 */
        }

        .loading-spinner img {
            width: 50px; /* 스피너 이미지 크기 조정 */
            height: 50px;
        }

        .no-more-products {
            text-align: center;
            color: #ddd;
            padding: 20px;
        }

        .more-link {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #d79672;
            text-decoration: none;
            margin-bottom: 20px; /* "더보기" 링크 하단 여백 추가 */
        }
    </style>
    <script>
        $(document).ready(function () {
            let loading = false; // 로딩 중 여부 flag
            let page = 1; // 시작 페이지 번호
            let hasMore = true; // 다음 페이지 존재 여부 flag (true: 다음 페이지 있음, false: 더 이상 상품 없음)

            const productListContainer = $('#product-list'); // 상품 목록 컨테이너
            const loadingSpinner = $('#loading-spinner'); // 로딩 스피너
            const noMoreProductsMessage = $('#no-more-products'); // "더 이상 상품 없음" 메시지

            function loadProducts() {
                if (loading || !hasMore) { // 로딩 중이거나, 더 이상 상품 없으면 return
                    return;
                }
                loading = true; // 로딩 시작 flag 설정
                loadingSpinner.removeClass('hidden'); // 로딩 스피너 표시

                const catId = new URLSearchParams(window.location.search).get('catId'); // URL 파라미터에서 catId 값 가져오기
                const searchQuery = new URLSearchParams(window.location.search).get('searchQuery'); // URL 파라미터에서 searchQuery 값 가져오기
                const searchType = new URLSearchParams(window.location.search).get('searchType'); // URL 파라미터에서 searchType 값 가져오기


                $.ajax({
                    url: '<c:url value="/prod/list-partial"/>', // 상품 목록 AJAX 요청 URL (/prod/list/another 컨트롤러 사용)
                    type: 'GET',
                    data: {
                        page: page,
                        catId: catId,
                        searchQuery: searchQuery,
                        searchType: searchType
                    },
                    dataType: 'html', // HTML 응답으로 받기 (컨트롤러에서 Slice<Product> 대신 ModelAndView 반환하도록 수정해야 함)
                    success: function (data) {
                        loading = false; // 로딩 완료 flag 해제
                        loadingSpinner.addClass('hidden'); // 로딩 스피너 숨김

                        if (data.trim() === "") { //  더 이상 상품 없으면 처리 (HTML 응답이 비어있는지 확인)
                            hasMore = false; // 다음 페이지 없음 flag 설정
                            noMoreProductsMessage.removeClass('hidden'); // "더 이상 상품 없음" 메시지 표시
                            $(window).off('scroll', handleScroll); // 스크롤 이벤트 핸들러 해제 (더 이상 스크롤 이벤트 불필요)
                            return;
                        }

                        productListContainer.append(data); // 받아온 HTML 상품 목록을 상품 목록 컨테이너에 추가
                        page++; // 페이지 번호 증가
                    },
                    error: function (xhr, status, error) {
                        loading = false; // 로딩 완료 flag 해제
                        loadingSpinner.addClass('hidden'); // 로딩 스피너 숨김
                        console.error("상품 목록 로딩 실패:", error);
                        alert("상품 목록 로딩 중 오류가 발생했습니다."); // 사용자에게 오류 알림 (alert 대신 modal 또는 다른 UI 방식으로 개선 가능)
                    }
                });
            }

            function handleScroll() { // 스크롤 이벤트 핸들러 함수
                if (loading || !hasMore) { // 로딩 중이거나, 더 이상 상품 없으면 return
                    return;
                }
                // 페이지 하단 감지 조건 (window height + scroll top >= document height - 300px)
                if ($(window).scrollTop() + $(window).height() >= $(document).height() - 300) { // 300px 여유 공간
                    loadProducts(); // 상품 목록 로딩 함수 호출 (다음 페이지 로딩)
                }
            }

            loadProducts(); // 페이지 로딩 시 최초 상품 목록 로딩 (1페이지)

            $(window).on('scroll', handleScroll); // 스크롤 이벤트 핸들러 등록 (무한 스크롤 활성화)
        });
    </script>
</head>
<body class="custom-scrollbar">
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <%@include file="include/category.jsp" %>
        <div class="main-container">
            <h2>상품 목록</h2>
            <div id="product-list" class="product-list">
                <%-- 상품 목록이 여기에 표시됩니다 (JavaScript - 무한 스크롤) --%>
                <%--<c:forEach var="product" items="${productList}">
                    <div class="product">
                        <div class="product-image-container">
                                &lt;%&ndash; JSP EL 로 imageUrls (첫 번째 이미지 URL) 직접 접근 &ndash;%&gt;
                            <c:choose>
                                <c:when test="${not empty product.listImageUrls[0]}">
                                    <img src="${product.listImageUrls[0]}" alt="Product Image" class="product-image"/>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/250x200?text=No+Image" alt="No Image"
                                         class="product-image"/> &lt;%&ndash; 대체 이미지 &ndash;%&gt;
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
                            <a href="<c:url value="/prod/${product.prodId}"/>"
                               class="product-spec-button">상세보기</a>
                        </div>
                    </div>
                </c:forEach>--%>
            </div>

            <div id="loading-spinner" class="loading-spinner hidden"> <%-- hidden 클래스 추가 --%>
                <img src="/images/loading_spinner.gif" alt="Loading..."> <%-- 로딩 스피너 이미지 --%>
            </div>
            <p id="no-more-products" class="no-more-products hidden">더 이상 상품이 없습니다.</p> <%-- hidden 클래스 추가 --%>
            <a href="<c:url value="/prod/list?page=1&size=99999"/>" class="more-link">더보기</a> <%-- "더보기" 링크 추가 --%>
        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</div>
</body>
</html>