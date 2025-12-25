<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제</title>
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
            text-align: left;  /* 왼쪽 정렬 */
            display: flex;     /* 버튼들을 한 줄로 표시 */
            gap: 10px;         /* 버튼 간격 추가 */
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
            margin: 15% auto;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 500px;
            position: relative; /* for close button positioning */
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

    </style>

    <script>
        function submitPaymentForm(event) {
            event.preventDefault();

            const form = document.getElementById("paymentForm");
            const buyerId = form.buyerId.value;
            const sellerId = form.sellerId.value;
            const amountValue = parseInt(form.amount.value, 10);

            // formData 객체 생성 및 값 할당을 명시적으로 작성
            const formData = {
                buyerId: buyerId,
                sellerId: sellerId,
                amount: isNaN(amountValue) ? 0 : amountValue
            };

            const paymentUrl = "/api/points/payment";

            // 전송되는 데이터 확인을 위한 console.log 추가
            console.log("전송될 데이터:", formData);

            fetch(paymentUrl, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(formData)
            })
                .then(response => response.json())
                .then(data => {
                    const modal = document.getElementById("paymentModal");
                    const resultContainer = document.getElementById("result");

                    if (data && data.transferId) {
                        resultContainer.style.color = "green";
                        resultContainer.innerHTML =
                            "결제가 성공적으로 처리되었습니다:<br>" +
                            "결제 ID: " + data.transferId + "<br>" +
                            "송신자 ID: " + data.senderId + "<br>" +
                            "수신자 ID: " + data.receiverId + "<br>" ;

                    } else if (data && data.message) {
                        resultContainer.style.color = "red";
                        resultContainer.innerText = "결제 실패: " + data.message;
                    } else {
                        resultContainer.style.color = "red";
                        resultContainer.innerText = "결제 실패: 알 수 없는 오류가 발생했습니다.";
                    }

                    modal.style.display = "block";
                })
                .catch(error => {
                    const modal = document.getElementById("paymentModal");
                    const resultContainer = document.getElementById("result");

                    resultContainer.style.color = "red";
                    resultContainer.innerText = "결제 요청 중 오류가 발생했습니다: " + error.message;

                    modal.style.display = "block";
                });
        }

        function closeModal() {
            const modal = document.getElementById("paymentModal");
            const form = document.getElementById("paymentForm");

            modal.style.display = "none";
            form.reset();
        }

        function navigateToRefund() {
            window.location.href = "/api/points/refund";
        }

        function navigateToRecharge() {
            window.location.href = "/api/points/charge";
        }

        function goBack() {
            window.location.href = "/";
        }
    </script>

</head>
<body>
<!-- 메인 버튼 -->
<button class="main-button-left" onclick="goBack()">메인 페이지로</button>

<!-- 컨테이너 -->
<div class="container">
    <form id="paymentForm" onsubmit="submitPaymentForm(event)">
        <h1>포인트 결제</h1>

        <label for="buyerId">구매자 ID:</label>
        <input type="number" id="buyerId" name="buyerId" required>

        <label for="sellerId">판매자 ID:</label>
        <input type="number" id="sellerId" name="sellerId" required>

        <label for="amount">결제 금액:</label>
        <input type="number" id="amount" name="amount" min="1" required>

        <button type="submit">결제하기</button>
    </form>

    <!-- 하단 버튼 -->
    <div class="bottom-buttons">
        <button type="button" onclick="navigateToRecharge()">포인트 충전</button>
        <button type="button" onclick="navigateToRefund()">환불</button>
    </div>
</div>

<div id="paymentModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">×</span>
        <div id="result"></div>
    </div>
</div>

</body>
</html>