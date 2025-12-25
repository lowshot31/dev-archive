# 🤖 Upbit Coinbot (급등 알림 봇)

업비트(Upbit) 거래소의 실시간 시세를 모니터링하여, 짧은 시간 내에 급등하는 코인을 감지하고 텔레그램으로 즉시 알림을 보내주는 봇입니다.

## ✨ 주요 기능

-   **실시간 전수 조사**: 업비트의 모든 **KRW(원화)** 마켓을 모니터링합니다. (API 제한 준수)
-   **급등 감지 알고리즘**: 1분봉 기준으로 설정된 임계값(기본 10%) 이상 급등 시 알림 발송.
-   **텔레그램 연동**: 스마트폰이나 PC 텔레그램으로 편리하게 알림을 받을 수 있습니다.
-   **다중 사용자 지원**: 여러 사용자가 동시에 봇을 이용할 수 있습니다.
-   **실시간 제어**: 텔레그램 명령어로 봇 상태 확인 및 설정 변경 가능.

## 📱 텔레그램 명령어 사용법

| 명령어 | 설명 | 예시 |
| :--- | :--- | :--- |
| **/start** | 알림 서비스를 시작하고 사용자를 등록합니다. | `/start` |
| **/stop** | 알림 서비스를 중지하고 등록을 해제합니다. | `/stop` |
| **/status** | 현재 봇의 상태(등록 사용자 수, 감지 기준 등)를 확인합니다. | `/status` |
| **/test** | 테스트 알림을 발송하여 봇 동작을 확인합니다. | `/test` |
| **/set_threshold** | 급등 감지 기준(%)을 변경합니다. (기본값: 10%) | `/set_threshold 5` (5% 이상 상승 시 알림) |

## 🛠 기술 스택

-   **Language**: Python 3.9+
-   **Core Libraries**:
    -   `python-telegram-bot` (v20+): Telegram Async API
    -   `requests`: HTTP Client
    -   `asyncio`: 비동기 동시성 처리

## 🚀 설치 및 실행 방법

### 1. 환경 설정

```bash
# 1. 저장소 클론
git clone https://github.com/lowshot31/lowshot31.git
cd lowshot31/coinbot

# 2. 필수 라이브러리 설치
pip install python-telegram-bot requests
```

### 2. 봇 설정 (선택 사항)

보안을 위해 텔레그램 토큰을 환경 변수로 설정하는 것을 권장합니다. 설정하지 않으면 코드 내 기본값(테스트용)이 사용됩니다.

**Windows PowerShell:**
```powershell
$env:TELEGRAM_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
```

**Linux/Mac:**
```bash
export TELEGRAM_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
```

### 3. 실행

```bash
python main.py
```

실행 후 터미널에 로그가 출력되며 모니터링이 시작됩니다. 텔레그램에서 봇에게 말을 걸어보세요!

## 🔍 감지 로직 상세

1.  **60초 주기**로 업비트의 모든 KRW 마켓 스캔
2.  각 코인의 **최근 1분봉(Candle)** 조회
3.  `(현재가 - 직전 1분봉 종가) / 직전 1분봉 종가 * 100` 계산
4.  설정된 임계값(Threshold) 이상일 경우 즉시 알림 전송

## 📊 알림 예시

```
🚀 급등 알림!
━━━━━━━━━━━━━━━
📌 코인: KRW-BTC
📈 상승률: +12.45%
💰 현재가: 45,000,000원
```

## ⚙️ 설정 커스터마이징

`main.py` 파일에서 다음 설정을 변경할 수 있습니다:

```python
# 급등 감지 임계값 (%)
SPIKE_THRESHOLD = 5

# 모니터링 주기 (초)
MONITOR_INTERVAL = 60
```

## 🏗️ 코드 구조

```
coinbot/
├── main.py              # 메인 애플리케이션
├── test_coinbot.py      # 테스트 코드
├── telebot.txt          # 텔레그램 봇 토큰 (보안 주의!)
└── README.md            # 프로젝트 문서
```

## ⚠️ 주의사항

-   이 봇은 매수/매도를 자동으로 수행하지 않는 **정보 제공용** 봇입니다.
-   투자의 책임은 전적으로 사용자에게 있습니다.
-   업비트 API의 요청 제한(초당 10회 등)을 준수하도록 설계되었습니다.
-   `telebot.txt` 파일에는 민감한 정보가 포함되어 있으므로 공개 저장소에 커밋하지 마세요.

## 🔒 보안 권장사항

1. **환경 변수 사용**: 텔레그램 토큰을 코드에 직접 넣지 말고 환경 변수로 관리
2. **`.gitignore` 설정**: `telebot.txt` 파일을 Git에서 제외
3. **토큰 재발급**: 토큰이 노출된 경우 즉시 BotFather에서 재발급

## 🚧 향후 개선 계획

- [ ] 데이터베이스 연동 (사용자 설정 영구 저장)
- [ ] 다중 마켓 지원 (USDT, BTC 마켓)
- [ ] 웹 대시보드 추가
- [ ] 가격 알림 기능 (특정 가격 도달 시 알림)
- [ ] 거래량 급증 감지

## 📞 문의 및 기여

- **이슈 리포트**: GitHub Issues
- **기능 제안**: Pull Requests 환영

## 📚 참고 자료

- [Upbit API 문서](https://docs.upbit.com/)
- [python-telegram-bot 문서](https://docs.python-telegram-bot.org/)
- [Asyncio 가이드](https://docs.python.org/3/library/asyncio.html)

---

**© 2025 Upbit Coinbot Project**
