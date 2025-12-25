#emart24 pageNation에서 페이지 len을 가져온 후 그 만큼 버튼을 누르는 식으로 가져온다.
#맨처음에 pIndexfocus에서 len(길이)가져 온 후 for문 돌린다 그 이후 다시 리콜 해서 확인
#while문을 통해서 페이지수 확인 -> for 상품 리스트를 가져온 후 pIndexfocus의 길이 <10 일시 종료.
from drivers import driver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import time

url = 'https://emart24.co.kr/product/eventProduct.asp'
driver.get(url)
wait = WebDriverWait(driver,10)
total_length ='div.viewContentsWrap div.mainContents div.pageNationWrap ul.pageNation'
next_btn = 'div.viewContentsWrap div.mainContents div.pageNationWrap div.nextButtons div.next'
item_list = 'div.mainContents section.itemList.active div.itemWrap'
event_id = 'div.itemTit span'
item_img_id = 'div.mainContents section.itemList.active div.itemWrap div.itemImg img'
prod_name_id = 'div.mainContents section.itemList.active div.itemWrap div.itemTxtWrap div.itemtitle p a'
prod_price_id =  'div.mainContents section.itemList.active div.itemWrap div.itemTxtWrap span a.price'



def count_page():
    item_num = driver.find_element(By.CSS_SELECTOR,total_length).find_elements(By.CSS_SELECTOR,'li.pIndex')
    page_length = len([i for i in item_num])
    return get_item(int(page_length))

def get_item(page_length = int):
    if page_length !=10: 
        for i in range(1,page_length+1):
            # item wrap을 가져와야함
            items = driver.find_elements(By.CSS_SELECTOR,item_list)
            for index,item in enumerate(items):
                span = item.find_elements(By.CSS_SELECTOR,event_id)
                event = span[-1].get_attribute('textContent')
                item_img = item.find_element(By.CSS_SELECTOR,item_img_id).get_attribute('src')
                prod_name = item.find_element(By.CSS_SELECTOR,prod_name_id).get_attribute('textContent')
                price = item.find_element(By.CSS_SELECTOR,prod_price_id).get_attribute('textContent').split('원')[0]
                print(f"{event} 이미지{item_img} 상품이름 : {prod_name} 가격 : {price}")
            next_pg = driver.find_element(By.CSS_SELECTOR,next_btn)
            next_pg.click()
            time.sleep(5)
    else:
        for i in range(1,page_length+1):
            items = driver.find_elements(By.CSS_SELECTOR,item_list)
            for index,item in enumerate(items):
                span = item.find_elements(By.CSS_SELECTOR,event_id)
                event = span[-1].get_attribute('textContent')
                item_img = item.find_element(By.CSS_SELECTOR,item_img_id).get_attribute('src')
                prod_name = item.find_element(By.CSS_SELECTOR,prod_name_id).get_attribute('textContent')
                price = item.find_element(By.CSS_SELECTOR,prod_price_id).get_attribute('textContent').split('원')[0]
                print(f"{event} 이미지{item_img} 상품이름 : {prod_name} 가격 : {price}")
            next_pg = driver.find_element(By.CSS_SELECTOR,next_btn)
            next_pg.click()
            time.sleep(5)
    if page_length != 10:
        return 0
    else:
        count_page()
count_page()
    