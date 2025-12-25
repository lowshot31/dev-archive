$(function () {
    // Add custom pattern method
    $.validator.addMethod("pattern", function (value, element, param) {
        if (this.optional(element)) {
            return true;
        }
        if (typeof param === "string") {
            param = new RegExp("^(?:" + param + ")$");
        }
        return param.test(value);
    }, "Invalid format.");

    $("#register").validate({
        rules: {
            loginId: {
                pattern: /^[a-z0-9_]*$/,
                required: true,
                minlength: 6,
                maxlength: 20,
            },
            password: {
                pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]+$/,
                required: true,
                minlength: 10,
                maxlength: 30,
            },
            passwordCheck: {
                required: true,
                equalTo: "#password"
            },
            email: {
                required: true,
                email: true
            },
            name: {
                required: true,
                pattern: /^[가-힣a-zA-Z]*$/,
                minlength: 1,
                maxlength: 20,
            },
            nickname: {
                required: true,
                pattern: /^[가-힣a-zA-Z]*$/,
                minlength: 2,
                maxlength: 20,
            },
        },
        messages: {
            loginId: {
                required: "아이디를 입력 해 주세요.",
                minlength: "아이디는 6자 이상이어야 합니다.",
                maxlength: "아이디는 20자 이하여야 합니다.",
                pattern: "아이디는 영문 소문자, 숫자, 언더 바(_) 만 사용할 수 있습니다."
            },
            password: {
                required: "비밀번호를 입력 해 주세요.",
                minlength: "비밀번호는 10자 이상이어야 합니다.",
                maxlength: "비밀번호는 30자 이하여야 합니다.",
                pattern: "비밀번호는 영문 대소문자, 숫자, 특수문자(@$!%*?&.)를 모두 포함해야 합니다."
            },
            passwordCheck: {
                required: "비밀번호를 다시 입력 해 주세요.",
                equalTo: "비밀번호가 일치하지 않습니다."
            },
            email: {
                required: "이메일을 입력 해 주세요.",
                email: "이메일 형식이 올바르지 않습니다."
            },
            name: {
                required: "이름을 입력 해 주세요.",
                minlength: "이름은 1자 이상이어야 합니다.",
                maxlength: "이름은 20자 이하여야 합니다.",
                pattern: "이름은 한글과 영문 대소문자만 사용할 수 있습니다."
            },
            nickname: {
                required: "닉네임을 입력 해 주세요.",
                minlength: "닉네임은 2자 이상이어야 합니다.",
                maxlength: "닉네임은 20자 이하여야 합니다.",
                pattern: "닉네임은 한글과 영문 대소문자만 사용할 수 있습니다."
            },
        },
        errorPlacement: function (error, element) {
            $(element).attr("title", error.text()).tooltip({
                position: {
                    my: "left+15 center",
                    at: "right center"
                }
            }).tooltip("open");
        },
        success: function (label, element) {
            $(element).tooltip("destroy");
        },
        highlight: function (element, errorClass, validClass) {
            if (!$(element).data("ui-tooltip")) {
                $(element).tooltip({
                    position: {
                        my: "left+15 center",
                        at: "right center"
                    }
                });
            }
            $(element).addClass("is-invalid").removeClass("is-valid").tooltip("open");
        },
        unhighlight: function (element, errorClass, validClass) {
            if ($(element).data("ui-tooltip")) {
                $(element).removeClass("is-invalid").addClass("is-valid").tooltip("close");
            }
        }
    });

    // Add keyup event to trigger validation on input
    $("#register input").on("keyup", function () {
        $(this).valid();
    });
});