from selenium import webdriver
from selenium.webdriver.chrome.options import Options

option = Options()
option.add_experimental_option("detach", True)
option.add_argument('headless')
option.add_argument('window-size=1920x1080')
option.add_argument("disable-gpu")
option.add_experimental_option("excludeSwitches", ["enable-logging"])

driver = webdriver.Chrome(options=option)