<%--
  Created by IntelliJ IDEA.
  User: USER
  Date: 24. 12. 24.
  Time: 오후 1:16
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <%--jquery ui--%>
    <script src="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.css"/>">


    <link rel="stylesheet" href="<c:url value='/style/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/style/header.css'/>">

    <%--    <script src="<c:url value='/script/modalCache.js'/>"></script>--%>
    <script src="<c:url value='/script/modal.js'/>"></script>

    <script>
        function search(query) {
            if (!query) {
                alert('검색어를 입력하세요.');
                return;
            }
            location.href = 'http://localhost/prod/list?searchType=title-desc&searchQuery=' + query;

        }
    </script>
</head>
<div id="modalContainer"></div>
<body>
<header class="header">
    <div class="header-top">
        <nav class="header-menu">
            <ul class="list-menu">
                <li><a href="<c:url value="/notifications"/>">알림</a></li>
                <li><a href="<c:url value="/board"/>">게시판</a></li>
                <sec:authorize access="isAuthenticated()">
                    <li><a href="<c:url value="/member"/>">내 정보</a></li>
                    <li><a href="<c:url value="/prod/register"/>">상품등록</a></li>
                    <li><a href="<c:url value="/member/logout"/>">로그아웃</a></li>
                </sec:authorize>
                <sec:authorize access="!isAuthenticated()">
                    <li><a href="#" id="href-open-login-header">로그인</a></li>
                </sec:authorize>
            </ul>
        </nav>
        <div class="header-logo">
            <a href="http://localhost">Sell&Buy</a>
        </div>
    </div>
    <div class="search-bar">
        <label>
            <input id="search-query" type="text" placeholder="상품 검색"
                   onkeydown="if (event.keyCode === 13) search(this.value)"/>
        </label>
        <button id="search-btn" type="button"
                onclick="search($('#search-query').val())">🔍
        </button>
    </div>
</header>
</body>
</html>
