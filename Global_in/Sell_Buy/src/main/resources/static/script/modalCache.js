let loginPageCache = null;
let registerPageCache = null;
$(function () {
    // Preload modal content asynchronously
    $.get('/member/login', function (data) {
        console.log('Login content loaded');
        loginPageCache = data;
    }).fail(function (error) {
        console.error('Failed to load login content:', error);
    });

    $.get('/member/register', function (data) {
        console.log('Register content loaded');
        registerPageCache = data;
    }).fail(function (error) {
        console.error('Failed to load register content:', error);
    });

});