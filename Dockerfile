FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg ca-certificates \
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdbus-1-3 libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 \
    libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libgbm1 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Chrome (from your URL)
RUN wget https://storage.googleapis.com/chrome-for-testing-public/140.0.7339.5/linux64/chrome-linux64.zip \
    && unzip chrome-linux64.zip \
    && mv chrome-linux64 /opt/chrome \
    && ln -s /opt/chrome/chrome /usr/bin/google-chrome \
    && rm chrome-linux64.zip

# Download and install ChromeDriver (from your URL)
RUN wget https://storage.googleapis.com/chrome-for-testing-public/140.0.7339.5/linux64/chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm -rf chromedriver-linux64* 

# Set environment variables for headless Chrome
ENV CHROME_BIN=/usr/bin/google-chrome
ENV PATH=$PATH:/usr/bin

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Streamlit app
COPY . /app
WORKDIR /app

CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.enableCORS=false"]

