import unittest
import asyncio
from unittest.mock import MagicMock, patch
import main  # coinbot.main 모듈 임포트

class TestCoinbot(unittest.TestCase):

    def test_chunk_markets(self):
        """마켓 리스트가 올바르게 청크로 나뉘는지 테스트"""
        markets = list(range(25))
        chunks = list(main.chunk_markets(markets, 10))
        self.assertEqual(len(chunks), 3)
        self.assertEqual(len(chunks[0]), 10)
        self.assertEqual(len(chunks[1]), 10)
        self.assertEqual(len(chunks[2]), 5)
        print("✅ chunk_markets 테스트 통과")

    @patch('requests.get')
    def test_get_all_krw_market(self, mock_get):
        """마켓 목록 조회 로직 테스트"""
        # API 응답 모의
        mock_response = MagicMock()
        mock_response.json.return_value = [
            {'market': 'KRW-BTC'},
            {'market': 'KRW-ETH'},
            {'market': 'USDT-BTC'},
            {'market': 'BTC-ETH'},
            {'market': 'KRW-XRP'}
        ]
        mock_get.return_value = mock_response

        krw, usdt, btc = main.get_all_krw_market()
        
        self.assertEqual(len(krw), 3) # KRW-BTC, KRW-ETH, KRW-XRP
        self.assertIn('KRW-BTC', krw)
        self.assertEqual(len(usdt), 1) # USDT-BTC
        self.assertEqual(len(btc), 1) # BTC-ETH
        print("✅ get_all_krw_market 테스트 통과")

    @patch('main.asyncio.sleep', return_value=None) # sleep 시간을 0으로
    @patch('requests.get')
    def test_detect_spikes(self, mock_get, mock_sleep):
        """급등 감지 로직 테스트"""
        # 모의 데이터 설정
        # 1. 정상 코인 (변동 없음)
        normal_response = MagicMock()
        normal_response.json.return_value = [
            {"trade_price": 10000}, # 현재가
            {"trade_price": 10000}  # 전분가
        ]
        
        # 2. 급등 코인 (10% 이상 상승)
        spike_response = MagicMock()
        spike_response.json.return_value = [
            {"trade_price": 11500}, # 현재가 (15% 상승)
            {"trade_price": 10000}  # 전분가
        ]

        # 3. 데이터 부족
        empty_response = MagicMock()
        empty_response.json.return_value = []

        # requests.get이 호출될 때마다 다른 응답을 주도록 설정
        # KRW-BTC (정상), KRW-ETH (급등), KRW-XRP (데이터부족) 순서라고 가정
        mock_get.side_effect = [normal_response, spike_response, empty_response]

        markets = ['KRW-BTC', 'KRW-ETH', 'KRW-XRP']
        
        # 비동기 함수 실행
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        spikes = loop.run_until_complete(main.detect_spikes(markets))
        loop.close()

        self.assertEqual(len(spikes), 1)
        market, rate, price = spikes[0]
        self.assertEqual(market, 'KRW-ETH')
        self.assertEqual(rate, 15.0)
        print("✅ detect_spikes 테스트 통과")

if __name__ == '__main__':
    unittest.main(argv=['first-arg-is-ignored'], exit=False)
