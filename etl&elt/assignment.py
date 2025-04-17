import requests
import pandas as pd

# 1️⃣ Extract: Mengambil data dari API JSONPlaceholder
url = "https://jsonplaceholder.typicode.com/users"
response = requests.get(url)
data = response.json()

# 2️⃣ Transform: Mengubah JSON ke bentuk tabular
users_list = []

for user in data:
    users_list.append({
        "id": user["id"],
        "name": user["name"],
        "username": user["username"],
        "email": user["email"],
        "phone": user["phone"],
        "website": user["website"],
        "address.street": user["address"]["street"],
        "address.suite": user["address"]["suite"],
        "address.city": user["address"]["city"],
        "address.zipcode": user["address"]["zipcode"],
        "address.geo.lat": user["address"]["geo"]["lat"],
        "address.geo.lng": user["address"]["geo"]["lng"],
        "company.name": user["company"]["name"],
        "company.catchPhrase": user["company"]["catchPhrase"],
        "company.bs": user["company"]["bs"]
    })

# Membuat DataFrame
df = pd.DataFrame(users_list)

# 3️⃣ Load: Menyimpan hasil ke file CSV
csv_filename = "users_data.csv"
df.to_csv(csv_filename, index=False)

print(f"Data berhasil disimpan ke {csv_filename}")
