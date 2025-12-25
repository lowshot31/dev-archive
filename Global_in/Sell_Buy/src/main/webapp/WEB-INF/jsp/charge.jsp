<%@ page contentType="text/html; charset=UTF-8" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포인트 충전</title>
    <link href="https://fonts.googleapis.com/earlyaccess/jejuhallasan.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Jeju Hallasan', sans-serif;
            background-color: #f5f5f5;
            color: #4e3629;
            padding: 20px;
        }

        h1 {
            color: #4e3629;
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            border: 2px solid #4e3629;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            font-size: 16px;
            margin-bottom: 8px;
            color: #4e3629;
        }

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 2px solid #4e3629;
            border-radius: 5px;
            background-color: #fff5e1;
            color: #4e3629;
        }

        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #c69c6d;
        }

        button {
            padding: 12px 25px;
            font-size: 16px;
            background-color: #c69c6d;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 5px;
        }

        button:hover {
            background-color: #9f7e4e;
        }

        .main-button-left {
            padding: 12px 25px;
            font-size: 16px;
            background-color: #4e3629;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            position: absolute;
            top: 20px;
            left: 20px;
        }

        .main-button-left:hover {
            background-color: #9f7e4e;
        }

        .bottom-buttons {
            margin-top: 30px;
        }

        .small-button {
            padding: 8px 15px;
            font-size: 14px;
            background-color: #c69c6d;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .small-button:hover {
            background-color: #9f7e4e;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4);
            overflow: auto;
        }

        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 30px;
            border-radius: 10px;
            width: 80%;
            max-width: 600px;  /* 크기 키움 */
        }

        .close {
            color: #4e3629;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 15px;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: #9f7e4e;
        }

        .result {
            color: #4e3629;
            font-size: 18px;
            text-align: center;
        }
    </style>

    <script>
        function submitChargeForm(event) {
            event.preventDefault();

            const form = document.getElementById("chargeForm");
            const memId = form.memId.value;
            const amount = form.amount.value;

            if (isNaN(memId) || isNaN(amount) || memId <= 0 || amount <= 0) {
                alert("회원 ID와 금액은 유효한 숫자여야 합니다.");
                return; // 유효하지 않으면 제출을 막음
            }

            const formData = {
                memId: parseInt(memId), // Long 타입에 맞게 숫자 처리
                amount: parseInt(amount) // 금액도 숫자로 처리
            };

            console.log(formData);  // formData 객체 확인 (console로 출력)

            const chargeUrl = "/api/points/charge"; // 엔드포인트도 변경된 엔티티 이름과 맞춤

            fetch(chargeUrl, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(formData)  // JSON 형태로 전달
            })
                .then(async response => {
                    const modal = document.getElementById("chargeModal");
                    const resultContainer = document.getElementById("result");

                    let errorData;

                    try {
                        errorData = await response.json();
                    } catch (error) {
                        errorData = { message: "서버 응답을 처리할 수 없습니다." };
                    }

                    if (response.ok) {
                        resultContainer.style.color = "green";
                        resultContainer.innerHTML =
                            "포인트 충전이 완료되었습니다:<br>" +
                            "메시지: " + errorData.message + "<br>" +
                            "회원 ID: " + errorData.chargerId + "<br>" +
                            "충전 금액: " + errorData.amount + "<br>" +
                            "충전 ID: " + errorData.chargeId + "<br>" +
                            "잔액: " + errorData.balanceAfter;
                    } else {
                        resultContainer.style.color = "red";
                        resultContainer.innerText = "충전 실패: " + errorData.message;
                    }

                    modal.style.display = "block";

                    // 입력값 초기화
                    form.memId.value = "";
                    form.amount.value = "";
                })
                .catch(error => {
                    const modal = document.getElementById("chargeModal");
                    const resultContainer = document.getElementById("result");

                    resultContainer.style.color = "red";
                    resultContainer.innerText = "충전 요청 중 오류가 발생했습니다: " + error.message;

                    modal.style.display = "block";

                    // 입력값 초기화
                    form.memId.value = "";
                    form.amount.value = "";
                });


        }

        function closeModal() {
            const modal = document.getElementById("chargeModal");
            const resultContainer = document.getElementById("result");

            modal.style.display = "none";  // 팝업 숨기기
            resultContainer.innerHTML = "";  // 텍스트 제거

            // 입력값 초기화
            const form = document.getElementById("chargeForm");
            form.memId.value = "";
            form.amount.value = "";
        }
        function navigateToRefund() {
            window.location.href = "/api/points/refund";
        }

        function navigateToPayment() {
            window.location.href = "/api/points/payment";
        }

        function goBack() {
            window.location.href = "/";  // 메인 페이지로 이동
        }
    </script>
</head>
<body>
<button class="main-button-left" onclick="goBack()">메인 페이지로</button>

<div class="container">
    <form id="chargeForm" onsubmit="submitChargeForm(event)">
        <h1>포인트 충전</h1>

        <label for="memId">회원 ID:</label>
        <input type="text" id="memId" name="memId" required>

        <label for="amount">충전 금액:</label>
        <input type="number" id="amount" name="amount" min="1" required>

        <button type="submit">충전하기</button>
    </form>

    <div class="bottom-buttons" align="left">
        <button type="button" onclick="navigateToPayment()">결제하러 가기</button>
        <button type="button" onclick="navigateToRefund()">충전 환불</button>
    </div>
</div>

<div id="chargeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <div id="result"></div>
    </div>
</div>
</body>
</html>
