<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sell&Buy :: 회원 정보 수정</title>
    <script src="<c:url value="/webjars/jquery/3.7.1/dist/jquery.js"/>"></script>
    <script src="<c:url value="/webjars/jquery-validation/1.20.0/jquery.validate.js"/>"></script>
    <script src="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/webjars/jquery-ui/1.14.1/jquery-ui.css"/>">
    <link rel="stylesheet" href="<c:url value="/style/common.css"/>">
    <link rel="stylesheet" href="<c:url value="/style/modal.css"/>">
    <%-- modal.css 도 필요 --%>
    <script src="<c:url value="/script/modal.js"/>"></script>
    <%-- modal.js 도 필요 --%>
    <script src="<c:url value="/script/registerValidation.js"/>"></script>
    <%-- 회원가입 validation script 재활용 --%>
    <style>
        .main-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            color: white;
        }

        .update-form {
            width: 80%;
            max-width: 600px;
            padding: 20px;
            border: 1px solid #444;
            border-radius: 8px;
            background-color: #332831;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            color: #333;
            font-size: 1em;
        }

        .form-submit-container {
            text-align: center;
            margin-top: 20px;
        }

        .update-button {
            padding: 12px 25px;
            background-color: #d79672;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
        }

        .update-button:hover {
            background-color: #b07860;
        }

        #update-failure {
            display: none;
            color: #cc0000;
            border: 1px solid #ff0000;
            background-color: #ffe6e6;
            opacity: 0.8;
            border-radius: 5px;
            font: 16px Arial, sans-serif;
            text-align: center;
            padding: 1%;
            margin-bottom: 1%;
            width: 100%;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('#update-button').click(function () {
                $('#updateForm').submit();
            });

            $('#updateForm').submit(function (event) {
                event.preventDefault();

                if (!$(this).valid()) { // jQuery Validation plugin validation
                    return;
                }

                let formData = {
                    nickname: $('#nickname').val(),
                    oldPassword: $('#oldPassword').val(), // 기존 비밀번호 추가
                    password: $('#password').val(),
                    name: $('#name').val(),
                    phoneNum: $('#phone').val(),
                    email: $('#email').val()
                };

                $.ajax({
                    type: 'PUT', // PUT 요청 사용
                    url: '<c:url value="/member"/>', // 회원 정보 수정 API URL
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function () {
                        alert('회원 정보가 수정되었습니다.');
                        window.location.href = '<c:url value="/member"/>'; // 내 정보 페이지로 리다이렉트
                    },
                    error: function (xhr, status, error) {
                        console.error("회원 정보 수정 실패:", xhr, status, error);
                        $('#update-failure').text("회원 정보 수정에 실패했습니다. 다시 시도해주세요. \n" + xhr.responseJSON?.message); // 서버 에러 메시지 표시
                        $('#update-failure').show(); // 실패 메시지 표시
                    }
                });
            });
        });
    </script>
</head>
<body class="custom-scrollbar">
<div id="wrap">
    <%@include file="include/header.jsp" %>
    <div class="content">
        <%@include file="include/category.jsp" %>
        <div class="main-container">
            <h2>회원 정보 수정</h2>

            <div id="update-failure"></div>
            <%-- 실패 메시지 영역 --%>

            <form id="updateForm" class="update-form">
                <div class="form-group">
                    <label for="nickname">닉네임</label>
                    <input type="text" id="nickname" name="nickname" value="${member.nickname}" placeholder="새 닉네임">
                </div>
                <div class="form-group">
                    <label for="oldPassword">기존 비밀번호</label>
                    <input type="password" id="oldPassword" name="oldPassword" placeholder="기존 비밀번호"
                           required> <%-- 기존 비밀번호 필드 추가 --%>
                </div>
                <div class="form-group">
                    <label for="password">새 비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="새 비밀번호">
                </div>
                <div class="form-group">
                    <label for="passwordCheck">새 비밀번호 확인</label>
                    <input type="password" id="passwordCheck" name="passwordCheck" placeholder="새 비밀번호 확인"
                           equalTo="#password">
                </div>
                <div class="form-group">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" value="${member.name}" placeholder="이름" required>
                </div>
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" value="${member.email}" placeholder="이메일" required>
                </div>
                <div class="form-group">
                    <label for="phone">전화번호</label>
                    <input type="tel" id="phone" name="phone" value="${member.phoneNum}" placeholder="전화번호" required>
                </div>

                <div class="form-submit-container">
                    <button type="submit" id="update-button" class="update-button">수정 완료</button>
                </div>
            </form>
        </div>
    </div>
    <%@include file="include/footer.jsp" %>
</div>
</body>
</html>