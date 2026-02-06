# Crypto & On-chain 데이터 명세서

## 1. 가상자산 시장 데이터
| 분류 | 세부 항목 | 추천 소스 | 수집 방식 | 목적 |
| :--- | :--- | :--- | :--- | :--- |
| 실시간 시세 | BTC, ETH, SOL 등 주요 페어 | Binance / Bybit | Websocket | 파생상품 거래 및 포지션 대응의 기준 가격 |
| 시장 점유율 | BTC Dominance | CoinMarketCap | REST API | 알트코인 시즌 및 비트코인 집중도 확인 |
| 로컬 지표 | 김치 프리미엄 | Upbit / Custom | REST API | 국내 투자 심리 과열 상태 측정 |

## 2. 파생상품 및 온체인 지표
| 분류 | 세부 항목 | 추천 소스 | 수집 방식 | 목적 |
| :--- | :--- | :--- | :--- | :--- |
| 파생 지표 | 미결제약정(OI), 펀딩비(FR), 롱숏비율 | Coinglass | REST/WS | 스마트 머니의 포지션 방향성 및 과열 분석 |
| 청산 데이터 | Liquidation Heatmap, 청산액 | Coinglass | Websocket | 매물대 지지/저항 및 연쇄 청산 구간 파악 |
| 고래 이동 | 대형 트랜잭션, 거래소 입출금 | Whale Alert | API/WS | 대규모 물량 투하 및 매집 시그널 선제 포착 |
| 자금 흐름 | 스테이블코인 거래소 유입량 | CryptoQuant | REST API | 대기 자금 규모 및 잠재적 매수 강도 파악 |

## 3. 심리 및 옵션
| 분류 | 세부 항목 | 추천 소스 | 수집 방식 | 목적 |
| :--- | :--- | :--- | :--- | :--- |
| 심리 지표 | 가상자산 Fear & Greed Index | Coinglass | REST API | 시장 전반의 투심 수치화 |
| 옵션 데이터 | BTC/ETH 옵션 미결제약정 및 만기일 | Deribit / Barchart | REST API | 만기일 변동성 및 Max Pain Price 파악 |
