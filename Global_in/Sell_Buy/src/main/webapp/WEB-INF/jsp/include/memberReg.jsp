<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Created by IntelliJ IDEA.
  User: USER
  Date: 25. 1. 13.
  Time: 오후 4:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <script src="<c:url value="/webjars/jquery-validation/1.20.0/jquery.validate.js"/>"></script>
    <script src="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.css"/>">
    <script src="<c:url value="/script/modal.js"/>"></script>
    <script src="<c:url value="/script/memberReg.js"/>"></script>
    <script src="<c:url value="/script/registerValidation.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <link rel="stylesheet" href="<c:url value="/style/modal.css"/>">
</head>
<body>
<div class="modal">
    <div class="modal_body">
        <h1>Sell&Buy</h1>
        <div id="register-failure">Register failed.</div>
        <form method="post" id="register">
            <input type="text" name="loginId" id="loginId" placeholder="아이디">
            <input type="password" name="password" id="password" placeholder="비밀번호">
            <input type="password" name="passwordCheck" id="passwordCheck" placeholder="비밀번호 확인">
            <input type="text" name="name" id="name" placeholder="이름">
            <input type="text" name="nickname" id="nickname" placeholder="닉네임">
            <input type="text" name="phone" id="phone" placeholder="전화번호">
            <input type="text" name="email" id="email" placeholder="이메일">
        </form>
        <div class="submit-container">
            <label class="is-membership">
                <a href="#" id="href-open-login">이미 회원이신가요?</a>
            </label>
            <button type="submit" class="modal-submit" id="register-button">회원가입</button>
        </div>
    </div>
</div>
</body>
</html>