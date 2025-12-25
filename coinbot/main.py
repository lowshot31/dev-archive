<<<<<<< HEAD
import os
=======
>>>>>>> backup/old-files
import requests
import tracemalloc
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
import asyncio

<<<<<<< HEAD
# 환경변수에서 토큰 읽기 (보안을 위해 코드에 직접 넣지 않음)
# 환경변수가 없으면 기본값 사용 (개발용)
TELEGRAM_TOKEN = os.environ.get("TELEGRAM_TOKEN", "7610300816:AAEBQqX7TZjFMtHDw0NLvcfaYvLzDvWlukE")

tracemalloc.start()
user_chat_ids = set()  # 중복 방지를 위한 집합

# 급등 감지 임계값 (%)
SPIKE_THRESHOLD = 5
# 모니터링 주기 (초)
MONITOR_INTERVAL = 60


def get_all_krw_market():
    """모든 KRW, USDT, BTC 마켓을 가져오는 함수"""
    url = "https://api.upbit.com/v1/market/all"
    try:
        response = requests.get(url).json()
        krw_markets = [market['market'] for market in response if market['market'].startswith('KRW-')]
        usdt_markets = [market['market'] for market in response if market['market'].startswith('USDT-')]
        btc_markets = [market['market'] for market in response if market['market'].startswith('BTC-')]
        return krw_markets, usdt_markets, btc_markets
    except Exception as e:
        print(f"마켓 조회 오류: {e}")
        return [], [], []


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """텔레그램 봇 시작 - 사용자 등록"""
    chat_id = update.effective_chat.id
    user_chat_ids.add(chat_id)  # ✅ 사용자 ID 저장
    
    await context.bot.send_message(
        chat_id=chat_id, 
        text=f"🎉 환영합니다! 급등 알림 서비스에 등록되었습니다.\n"
             f"📍 당신의 chat_id: {chat_id}\n"
             f"📊 현재 등록된 사용자 수: {len(user_chat_ids)}명\n\n"
             f"🚀 {SPIKE_THRESHOLD}% 이상 급등하는 코인이 감지되면 알림을 보내드립니다!"
    )
    
    # 마켓 정보 전송
    krw_markets, usdt_markets, btc_markets = get_all_krw_market()
    await context.bot.send_message(
        chat_id=chat_id, 
        text=f"📈 현재 모니터링 중인 마켓:\n"
             f"• KRW 마켓: {len(krw_markets)}개\n"
             f"• USDT 마켓: {len(usdt_markets)}개\n"
             f"• BTC 마켓: {len(btc_markets)}개"
    )


async def stop(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """알림 서비스 해제"""
    chat_id = update.effective_chat.id
    if chat_id in user_chat_ids:
        user_chat_ids.discard(chat_id)
        await context.bot.send_message(chat_id=chat_id, text="👋 알림 서비스가 해제되었습니다.")
    else:
        await context.bot.send_message(chat_id=chat_id, text="❓ 등록되지 않은 사용자입니다. /start로 먼저 등록해주세요.")


async def status(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """현재 상태 확인"""
    chat_id = update.effective_chat.id
    krw_markets, usdt_markets, btc_markets = get_all_krw_market()
    
    registered = "✅ 등록됨" if chat_id in user_chat_ids else "❌ 미등록"
    
    await context.bot.send_message(
        chat_id=chat_id,
        text=f"📊 봇 상태\n"
             f"━━━━━━━━━━━━━━━\n"
             f"• 등록 상태: {registered}\n"
             f"• 등록 사용자 수: {len(user_chat_ids)}명\n"
             f"• 모니터링 주기: {MONITOR_INTERVAL}초\n"
             f"• 급등 기준: {SPIKE_THRESHOLD}%\n"
             f"• KRW 마켓: {len(krw_markets)}개"
    )


def chunk_markets(markets, size=10):
    """업비트 API 제한(초당 10개)을 위해 마켓을 청크로 분할"""
    for i in range(0, len(markets), size):
        yield markets[i:i+size]


async def detect_spikes(markets):
    """급등 코인 감지 - 1분봉 기준으로 급등 여부 확인"""
    spiked = []
    
    for chunk in chunk_markets(markets, 10):
=======

TELEGRAM_TOKEN = "7610300816:AAEBQqX7TZjFMtHDw0NLvcfaYvLzDvWlukE"
tracemalloc.start()
user_chat_ids = set()  # 중복 방지를 위한 집합

# 모든 KRW 마켓과 USDT 마켓 BTC 마켓을 가져오는 함수
def get_all_krw_market():
    url = "https://api.upbit.com/v1/market/all"
    response = requests.get(url).json()
    krw_markets = [market['market'] for market in response if market['market'].startswith('KRW-')]
    usdt_markets = [market['market'] for market in response if market['market'].startswith('USDT-')]
    btc_markets = [market['market'] for market in response if market['market'].startswith('BTC-')]
    return krw_markets, usdt_markets, btc_markets


# 텔레그램 봇 시작
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.effective_chat.id
    await context.bot.send_message(chat_id=chat_id, text=f"환영합니다! 당신의 chat_id는 {chat_id}입니다.")
    # 마켓 데이터 참고로 보내기
    # markets = get_all_krw_market()
    # krw_markets = markets[0]
    # usdt_markets = markets[1]  
    # await context.bot.send_message(chat_id=chat_id, text=f"현재 KRW 마켓 수: {len(krw_markets)}")
    # await context.bot.send_message(chat_id=chat_id, text=f"현재 USDT 마켓 수: {len(usdt_markets)}")


# 업비트 api제한 때문에 10개씩 비동기로 묶은 후 초당 제한 요청을 지키며 순차 조회회
def chunk_markets(markets, size=10):
    for i in range(0, len(markets), size):
        yield markets[i:i+size]

async def detecet_spikes(markets):
    spiked = []
    for chunk in chunk_markets(markets,10):
>>>>>>> backup/old-files
        tasks = []
        for market in chunk:
            url = f"https://api.upbit.com/v1/candles/minutes/1?market={market}&count=2"
            tasks.append(asyncio.to_thread(requests.get, url))
<<<<<<< HEAD
        
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        
        for market, response in zip(chunk, responses):
            try:
                if isinstance(response, Exception):
                    continue
                    
                data = response.json()
                if len(data) < 2:
                    continue
                    
                now = data[0]["trade_price"]
                prev = data[1]["trade_price"]
                
                if prev == 0:
                    continue
                    
                rate = (now - prev) / prev * 100
                
                if rate >= SPIKE_THRESHOLD:
                    spiked.append((market, rate, now))
            except Exception:
                continue
        
        await asyncio.sleep(1)  # 초당 10개 제한 준수
    
    return spiked


async def monitor(app):
    """주기적으로 급등 코인을 모니터링하고 알림 전송"""
    print("🕵️ 급등 감시 시작...")
    
    while True:
        try:
            if not user_chat_ids:
                print("📭 등록된 사용자가 없습니다. 대기 중...")
                await asyncio.sleep(MONITOR_INTERVAL)
                continue
            
            krw_markets, _, _ = get_all_krw_market()
            
            if not krw_markets:
                print("⚠️ 마켓 정보를 가져오지 못했습니다.")
                await asyncio.sleep(MONITOR_INTERVAL)
                continue
            
            print(f"� {len(krw_markets)}개 마켓 스캔 중...")
            spike_coins = await detect_spikes(krw_markets)
            
            if spike_coins:
                print(f"🚀 {len(spike_coins)}개 급등 코인 감지!")
                
                for chat_id in user_chat_ids.copy():  # copy()로 순회 중 변경 방지
                    for market, rate, price in spike_coins:
                        message = (
                            f"🚀 급등 알림!\n"
                            f"━━━━━━━━━━━━━━━\n"
                            f"📌 코인: {market}\n"
                            f"📈 상승률: +{rate:.2f}%\n"
                            f"💰 현재가: {price:,.0f}원"
                        )
                        try:
                            await app.bot.send_message(chat_id=chat_id, text=message)
                        except Exception as e:
                            print(f"메시지 전송 실패 (chat_id: {chat_id}): {e}")
            else:
                print(f"📉 급등 코인 없음. {MONITOR_INTERVAL}초 후 재스캔...")
            
        except Exception as e:
            print(f"모니터링 오류: {e}")
        
        await asyncio.sleep(MONITOR_INTERVAL)


async def test_alert(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """테스트 알림 전송 (기능 확인용)"""
    chat_id = update.effective_chat.id
    message = (
        f"🧪 **테스트 알림**\n"
        f"━━━━━━━━━━━━━━━\n"
        f"📌 코인: KRW-TEST\n"
        f"📈 상승률: +99.99%\n"
        f"💰 현재가: 100,000,000원\n\n"
        f"✅ 봇이 정상적으로 메시지를 보낼 수 있습니다."
    )
    await context.bot.send_message(chat_id=chat_id, text=message)


async def set_threshold(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """감지 임계값 변경"""
    global SPIKE_THRESHOLD
    try:
        new_threshold = float(context.args[0])
        SPIKE_THRESHOLD = new_threshold
        await update.message.reply_text(f"✅ 급등 감지 기준이 {SPIKE_THRESHOLD}%로 변경되었습니다.")
    except (IndexError, ValueError):
        await update.message.reply_text("⚠️ 사용법: /set_threshold <숫자>\n예: /set_threshold 0.5")


async def post_init(application):
    """봇 초기화 후 실행될 콜백 - 모니터링 태스크 시작"""
    asyncio.create_task(monitor(application))


if __name__ == "__main__":
    # 봇 객체 생성 (post_init 등록)
    app = ApplicationBuilder().token(TELEGRAM_TOKEN).post_init(post_init).build()
    
    # 명령어 핸들러 등록
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("stop", stop))
    app.add_handler(CommandHandler("status", status))
    # 테스트용 명령어 추가
    app.add_handler(CommandHandler("test", test_alert))
    app.add_handler(CommandHandler("set_threshold", set_threshold))
    
    print("=" * 40)
    print("🤖 코인 급등 알림 봇 시작!")
    print("=" * 40)
    print(f"📊 급등 기준: {SPIKE_THRESHOLD}%")
    print(f"⏱️ 모니터링 주기: {MONITOR_INTERVAL}초")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("📱 텔레그램에서 /start 명령어로 알림을 받으세요!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    # 봇 폴링 시작 (이 함수가 루프를 관리함)
    app.run_polling()
=======
        responses = await asyncio.gather(*tasks)
        for market, response in zip(chunk, responses):
            try:
                data = response.json()
                if len(data) < 2:
                    continue
                now = data[0]["trade_price"]
                prev = data[1]["trade_price"]
                rate = (now - prev) / prev * 100
                if rate >= 10:
                    spiked.append((market, rate))
            except:
                continue
        
        await asyncio.sleep(1)  # 초당 10개 제한 준수

    return spiked
        
async def monitor():
    markets = get_all_krw_market()
    krw_markets = markets[0]
    usdt_markets = markets[1]   
    print("🕵️ 급등 감시 중...")
    spike_coin = await detecet_spikes(krw_markets)
    if spike_coin:
        for id in user_chat_ids:
            for market, rate in spike_coin:
                message = f"🚀 급등 알림: {market}가 {rate:.2f}% 상승했습니다!"
                await app.bot.send_message(chat_id=id, text=message)
# ✅ 메인 실행
if __name__ == "__main__":
    app = ApplicationBuilder().token(TELEGRAM_TOKEN).build()
    app.add_handler(CommandHandler("start", start))
    print("텔레그램 봇 실행 중... /start 눌러 chat_id를 확인하세요.")
    #비동기로 모니터링 기능 실행
    async def run():
        asyncio.create_task(monitor(app))
        await app.run_polling()
    asyncio.run(run())
>>>>>>> backup/old-files
