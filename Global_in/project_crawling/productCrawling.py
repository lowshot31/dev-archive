from  selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.wait import WebDriverWait
CHROMEDRIVER_PATH = './chromedriver.exe'
chrome_options = Options()
chrome_options.add_argument('headless')
chrome_options.add_argument('disable-gpu')
driver = webdriver.Chrome(executable_path=CHROMEDRIVER_PATH,chrome_options=chrome_options)