$(document).ready(function () {
    $('#register-button').click(function () {
        $('#register').submit();
    })
    $('#register').submit(function (event) {
        event.preventDefault();
        if (!$(this).valid()) {
            return;
        }
        let formData = {
            loginId: $('#loginId').val(),
            password: $('#password').val(),
            name: $('#name').val(),
            phoneNum: $('#phone').val(),
            email: $('#email').val(),
            nickname: $('#nickname').val()
        };
        $.ajax({
            type: 'POST',
            url: 'http://localhost/member/register',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function () {
                alert('회원가입이 완료되었습니다.');
                window.location.href = window.location.href;
            },
            error: function () {
                $('#register-failure').show();
            }
        });

    });
});