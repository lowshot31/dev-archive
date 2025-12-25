<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="https://static.toss.im/icons/png/4x/icon-toss-logo.png" />
    <link rel="stylesheet" href="<c:url value='/style/payment.css'/>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>토스페이먼츠 샘플 프로젝트</title>
  </head>
  <body>
  <h2>Success</h2>
  <p id="paymentKey"></p>
  <p id="orderId"></p>
  <p id="amount"></p>
  <script>
    // 쿼리 파라미터 값이 결제 요청할 때 보낸 데이터와 동일한지 반드시 확인하세요.
    // 클라이언트에서 결제 금액을 조작하는 행위를 방지할 수 있습니다.
    const urlParams = new URLSearchParams(window.location.search);
    const paymentKey = urlParams.get("paymentKey");
    const orderId = urlParams.get("orderId");
    const amount = urlParams.get("amount");

    async function confirm() {
      const requestData = {
        paymentKey: paymentKey,
        orderId: orderId,
        amount: amount,
      };

      const response = await fetch("/confirm", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestData),
      });

      const json = await response.json();

      if (!response.ok) {
        // 결제 실패 비즈니스 로직을 구현하세요.
        console.log(json);
        window.location.href = `/fail?message=${json.message}&code=${json.code}`;
      }

      // 결제 성공 비즈니스 로직을 구현하세요.
      console.log(json);
    }
    confirm();

    const paymentKeyElement = document.getElementById("paymentKey");
    const orderIdElement = document.getElementById("orderId");
    const amountElement = document.getElementById("amount");

    orderIdElement.textContent = "ordernum: " + orderId;
    amountElement.textContent = "payment: " + amount;
    paymentKeyElement.textContent = "paymentKey: " + paymentKey;
  </script>
  </body>
</html>
