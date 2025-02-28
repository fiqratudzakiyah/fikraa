import zipfile

# Nama file CSV yang akan dikompres
csv_filename = "users_data.csv"
zip_filename = "users_data.zip"

# Membuat file ZIP
with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
    zipf.write(csv_filename)

print(f"File {csv_filename} berhasil dikompres menjadi {zip_filename}")
