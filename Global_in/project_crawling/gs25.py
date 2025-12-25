from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from drivers import driver

url = "https://gs25.gsretail.com/gscvs/ko/products/event-goods"


driver.get(url)

# 페이지가 완전히 로드될 때까지 기다립니다.
wait = WebDriverWait(driver, 50)

wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".prod_list")))
sale_list = driver.find_element(By.CSS_SELECTOR,'.myptab').find_elements(By.TAG_NAME,'li')
sale_list[-1].click()
#마지막페이지 가져옴 
wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".next2")))
element = driver.find_element(By.CSS_SELECTOR, ".next2")
onclick_attribute = element.get_attribute('onclick')
last_page = int(onclick_attribute.split('.')[1].split('(')[-1].replace(')',''))
# CSS 선택자를 사용하여 요소 찾기
# 각 항목의 텍스트를 출력
for i in range(1,last_page+1):
    try:
        # 현재 페이지 번호를 가져옴 (id값으로 사용).
        # page = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".paging .num .on"))).text
        items = driver.find_element(By.CSS_SELECTOR,".prod_list").find_elements(By.TAG_NAME,'li')
        img = driver.find_element(By.CSS_SELECTOR,".prod_list").find_elements(By.TAG_NAME,"img")
        print(f"현재 페이지 = {i}")
        for index , item in enumerate(items):
            plus = item.find_element(By.CSS_SELECTOR,".prod_box .flag_box").get_attribute('textContent')
            # if plus == '덤증정':
            #     continue
            title = item.find_element(By.CSS_SELECTOR,".prod_box .tit").get_attribute('textContent')
            price = item.find_element(By.CSS_SELECTOR,".prod_box .price").get_attribute('textContent').split('원')[0]
            prod_img = img[index].get_attribute('src')
            print(f"상품 : {title} 가격 : {price} img : {prod_img} 행사{plus}")

        driver.execute_script(f"return goodsPageController.moveControl(1)")
        time.sleep(3)
    except:
        print(f"{Exception}")
driver.quit()

