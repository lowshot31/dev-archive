$(document).ready(function () {
    $('#login-button').click(function () {
        $('#login').submit();
    });

    $('#login').submit(function (event) {
        event.preventDefault();
        let formData = $(this).serialize();
        $.ajax({
            type: 'POST',
            url: 'http://localhost/member/login',
            data: formData,
            success: function () {
                window.location.href = window.location.href;
            },
            error: function (xhr) {
                $('#login-failure').show();
            }
        });
    });
});