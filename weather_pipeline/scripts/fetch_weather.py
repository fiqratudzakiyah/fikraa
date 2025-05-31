import requests
import pandas as pd
from sqlalchemy import create_engine
import time

API_KEY = "your_openweathermap_api_key"
CITIES = ["Jakarta", "Tokyo", "New York", "London", "Sydney"]
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

# PostgreSQL connection string
DB_URL = "postgresql+psycopg2://weather_user:weather_pass@localhost:5432/weather_db"
engine = create_engine(DB_URL)

def kelvin_to_celsius(kelvin):
    return kelvin - 273.15

def fetch_city_weather(city):
    params = {
        "q": city,
        "appid": API_KEY
    }
    response = requests.get(BASE_URL, params=params)
    if response.status_code == 200:
        data = response.json()
        main = data.get("main", {})
        wind = data.get("wind", {})
        weather = {
            "city": city,
            "temp_celsius": kelvin_to_celsius(main.get("temp", 0)),
            "humidity": main.get("humidity", 0),
            "pressure": main.get("pressure", 0),
            "wind_speed_kmh": wind.get("speed", 0) * 3.6,
            "timestamp": pd.Timestamp.now()
        }
        return weather
    else:
        print(f"Failed to fetch data for {city}: {response.status_code}")
        return None

def main():
    records = []
    for city in CITIES:
        weather = fetch_city_weather(city)
        if weather:
            records.append(weather)
        time.sleep(1)  # untuk hindari rate limit

    if records:
        df = pd.DataFrame(records)
        df.to_sql("weather_data", engine, if_exists="append", index=False)
        print("Data saved to database.")

if __name__ == "__main__":
    main()
