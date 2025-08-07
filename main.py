import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time

def launch_browser_and_open_google():
    st.write("🔧 Launching headless Chrome inside Docker...")

    # Set Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--headless=new")  # modern headless mode
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    # Service object without executable_path (uses default chromedriver in PATH)
    service = Service()

    # Launch driver
    try:
        driver = webdriver.Chrome(service=service, options=chrome_options)
        st.write("✅ Headless Chrome started.")

        # Open Google
        driver.get("https://www.google.com")
        st.write("🌐 Opened Google.com")
        st.write(f"Title: {driver.title}")

        # Optional: wait and debug print
        time.sleep(2)
        st.write("📄 Page Source snippet:")
        st.code(driver.page_source[:1000])

    except Exception as e:
        st.error(f"❌ Error: {e}")
    finally:
        try:
            driver.quit()
        except:
            pass

if st.button("Launch Google in Headless Chrome"):
    launch_browser_and_open_google()
