from drivers import driver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
import time

url = "https://cu.bgfretail.com/event/plus.do"

driver.get(url)

wait = WebDriverWait(driver, 50)

# 더보기 버튼이 없을 때까지 찾기
while True:                                                                     
    try:
        more_button = driver.find_element(By.CSS_SELECTOR, ".prodListBtn .prodListBtn-w a")
        driver.execute_script("arguments[0].click();", more_button)
        time.sleep(5)
    except Exception as e:
        print(e)
        break

prod_list = driver.find_elements(By.CSS_SELECTOR, '.prodListWrap ul li')  # 상품목록 가져오기
for item in prod_list:
    img = item.find_element(By.CSS_SELECTOR, '.prod_img img.prod_img').get_attribute('src')
    name = item.find_element(By.CSS_SELECTOR, '.prod_text div.name').get_attribute('textContent')  # 상품이름
    price = item.find_element(By.CSS_SELECTOR, '.prod_text div.price strong').get_attribute('textContent')  # 상품가격
    plus = item.find_element(By.CSS_SELECTOR, '.badge span').text  # 행사종류
    print(f"상품 이미지 : {img} 상품:{name} 가격 : {price} 이벤트 {plus}")

driver.quit()