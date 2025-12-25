<%--
  Created by IntelliJ IDEA.
  User: USER
  Date: 25. 1. 20.
  Time: 오전 11:36
  To change this template use File | Settings | File Templates.
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy :: Something Went Wrong!</title>
    <script src="<c:url value='/webjars/jquery/3.7.1/dist/jquery.js'/>"></script>
    <link rel="stylesheet" href="<c:url value='/style/common.css'/>">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f2f2f2;
            margin: 0;
            font-family: "jeju hallasan", sans-serif;
        }

        .error-container {
            text-align: center;
            padding: 20px;
        }

        .error-code {
            font-size: 10em;
            font-weight: bold;
            color: #e74c3c;
        }

        .error-message {
            font-size: 2em;
            color: #555;
        }
    </style>
</head>
<body class="custom-scrollbar">
<div class="error-container">
    <div class="error-code">
        <c:out value="${errorCode}"/> <!-- 에러 코드 -->
    </div>
    <div class="error-message">
        <c:out value="${errorMessage}"/> <!-- 에러 메시지 -->
    </div>
</div>
</body>
</html>
