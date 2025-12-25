var loginPageCache = null;
var registerPageCache = null;

$(document).ready(function () {

    function closeModal() {
        $('.modal').css('display', 'none');
        $('.modal_body [title]').each(function () {
            if ($(this).data('ui-tooltip')) {
                $(this).tooltip('destroy');
            }
        });
    }

    $('#href-open-login').on('click', function (event) {
        event.preventDefault();
        if (loginPageCache) {
            $('#modalContainer').html(loginPageCache);
            $('.modal').css('display', 'flex');
        } else {
            $.get('/member/login', function (data) {
                loginPageCache = data;
                $('#modalContainer').html(data);
                $('.modal').css('display', 'flex');
            });
        }
    });

    $('#href-open-login-header').on('click', function (event) {
        event.preventDefault();
        if (loginPageCache) {
            $('#modalContainer').html(loginPageCache);
            $('.modal').css('display', 'flex');
        } else {
            $.get('/member/login', function (data) {
                loginPageCache = data;
                $('#modalContainer').html(data);
                $('.modal').css('display', 'flex');
            });
        }
    });

    $('#href-open-register').on('click', function (event) {
        event.preventDefault();
        if (registerPageCache) {
            $('#modalContainer').html(registerPageCache);
            $('.modal').css('display', 'flex');
        } else {
            $.get('/member/register', function (data) {
                registerPageCache = data;
                $('#modalContainer').html(data);
                $('.modal').css('display', 'flex');
            });
        }
    });

    $(document).on('click', function (event) {
        if (!$(event.target).closest('.modal_body').length && !$(event.target).closest('#href-open-login').length && !$(event.target).closest('#href-open-register').length) {
            closeModal();
        }
    });

    $(document).on('click', '.modal_body', function (event) {
        event.stopPropagation();
    });

    // Example of how to close the modal (you can adjust this based on your actual implementation)
    $('#close-modal-button').click(function () {
        closeModal();
    });
});