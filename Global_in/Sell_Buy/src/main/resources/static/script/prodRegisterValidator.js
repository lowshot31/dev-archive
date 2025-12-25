$(function () {
    $.validator.addMethod("divisibleByTen", function (value, element, param) {
        if (this.optional(element)) {
            return true;
        }
        return value % 10 === 0;
    }, "10의 배수로 입력하세요.");
    $("#prodRegisterForm").validate({
        rules: {
            prodName: {
                required: true,
                minlength: 2,
                maxlength: 30
            },
            prodPrice: {
                required: true,
                number: true,
                max: 9999999999,
                divisibleByTen: true
            },
            prodDesc: {
                required: true,
                minlength: 20,
                maxlength: 100
            }
        },
        messages: {
            prodName: {
                required: "상품명을 입력하세요.",
                minlength: "상품명은 최소 2자 이상 입력하세요.",
                maxlength: "상품명은 최대 30자 이하 입력하세요."
            },
            prodPrice: {
                required: "상품 가격을 입력하세요.",
                number: "숫자만 입력하세요."
            },
            prodDesc: {
                required: "상품 설명을 입력하세요.",
                minlength: "상품 설명은 최소 20자 이상 입력하세요.",
                maxlength: "상품 설명은 최대 100자 이하 입력하세요."
            }
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

    $("#prodRegisterForm input").on("keyup", function () {
        $(this).valid();
    });

})