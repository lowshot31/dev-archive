<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 환불</title>
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
            margin: 15% auto;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 500px;
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
        // 모달 닫기 함수
        function closeModal() {
            document.getElementById("refundModal").style.display = "none";
        }

        // 메인 페이지로 이동
        function goBack() {
            window.location.href = "/"; // 메인 페이지 URL로 이동
        }

        // 포인트 충전 페이지로 이동
        function navigateToCharge() {
            window.location.href = "/api/points/charge"; // 포인트 충전 페이지 URL
        }

        // 결제 페이지로 이동
        function navigateToPayment() {
            window.location.href = "/api/points/payment"; // 결제 페이지 URL
        }

        // 새로고침하여 결제 환불 페이지 다시 로드
        function navigateToRefund() {
            window.location.reload(); // 현재 페이지 새로고침
        }

        // 환불 폼 전송 함수
        function submitRefundForm(event) {
            event.preventDefault();

            const form = document.getElementById("paymentRefundForm");
            const memId = form.memId.value.trim();
            const amount = form.amount.value.trim();

            if (!memId || isNaN(amount) || amount <= 0) {
                alert("유효한 회원 ID와 환불 금액을 입력하세요.");
                return;
            }

            const formData = {
                memId: Number(memId),
                amount: Number(amount),
            };

            fetch("/api/points/refund", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(formData),
            })
                .then(async response => {
                    const modal = document.getElementById("refundModal");
                    const resultContainer = document.getElementById("result");

                    let responseData;
                    try {
                        responseData = await response.json();
                    } catch (error) {
                        resultContainer.style.color = "red";
                        resultContainer.innerText = "서버 응답 형식이 올바르지 않습니다.";
                        modal.style.display = "block";
                        return;
                    }

                    if (response.ok) {
                        const refundResult = {
                            message: responseData.message,
                            memId: responseData.memId,
                            refundAmount: responseData.refundAmount,
                            bonusAmount: responseData.bonusAmount,
                            balanceAfter: responseData.balanceAfter
                        };

                        resultContainer.style.color = "#01080c";
                        resultContainer.innerHTML = `<strong>환불 성공!</strong><br>` +
                            `sell&bay를 이용해 주셔서 감사합니다`;
                        modal.style.display = "block";
                    } else {
                        resultContainer.style.color = "red";
                        resultContainer.innerText = `결제 환불 실패: ${responseData.message || '서버 오류 발생'}`;
                        modal.style.display = "block";
                    }
                    return responseData;
                })
                .catch(error => {
                    const modal = document.getElementById("refundModal");
                    const resultContainer = document.getElementById("result");
                    resultContainer.style.color = "red";
                    resultContainer.innerText = `환불 요청 중 오류가 발생했습니다.`; // 더 일반적인 메시지
                    modal.style.display = "block";
                    console.error("환불 처리 중 오류 발생:", error)
                });
        }
    </script>
</head>

<body>
<!-- 메인 페이지 이동 버튼 -->
<button class="main-button-left" onclick="goBack()">메인 페이지로</button>

<!-- 환불 폼 -->
<div class="container">
    <form id="paymentRefundForm" onsubmit="submitRefundForm(event)">
        <h1>포인트 환불</h1>

        <label for="memId">회원 ID:</label>
        <input type="number" id="memId" name="memId" required />

        <label for="amount">환불 금액:</label>
        <input type="number" id="amount" name="amount" min="1" required />

        <button type="submit">환불하기</button>
    </form>

    <!-- 하단 버튼 -->
    <div class="bottom-buttons" align="left">
        <button type="button" onclick="navigateToCharge()">포인트 충전하기</button>
        <button type="button" onclick="navigateToPayment()">결제하러 가기</button>
    </div>
</div>

<!-- 결과 모달 -->
<div id="refundModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">×</span>
        <div id="result"></div>
    </div>
</div>
</body>
</html>