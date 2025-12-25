<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- prodList.jsp 에서 상품 목록 부분만 추출한 파일 (무한 스크롤 용) --%>


<c:forEach var="product" items="${productList}">
    <div class="product">
        <div class="product-image-container">
                <%-- JSP EL 로 imageUrls (첫 번째 이미지 URL) 직접 접근 --%>
            <c:choose>
                <c:when test="${not empty product.listImageUrls[0]}">
                    <img src="${product.listImageUrls[0]}" alt="Product Image" class="product-image"/>
                </c:when>
                <c:otherwise>
                    <img src="https://via.placeholder.com/250x200?text=No+Image" alt="No Image"
                         class="product-image"/> <%-- 대체 이미지 --%>
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
</c:forEach>