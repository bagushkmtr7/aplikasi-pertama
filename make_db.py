import sqlite3
import os

# Buat folder jika belum ada
os.makedirs('assets/databases', exist_ok=True)

# Daftar surah Madaniyah (sisanya Makkiyah) sesuai standar internasional
madaniyah = [2, 3, 4, 5, 8, 9, 13, 22, 24, 33, 47, 48, 49, 55, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 76, 98, 99, 110]

conn = sqlite3.connect('assets/databases/surah_info.db')
cursor = conn.cursor()
cursor.execute('CREATE TABLE IF NOT EXISTS info (no INTEGER PRIMARY KEY, location TEXT)')

for i in range(1, 115):
    loc = "Madinah" if i in madaniyah else "Mekkah"
    cursor.execute('INSERT OR REPLACE INTO info (no, location) VALUES (?, ?)', (i, loc))

conn.commit()
conn.close()
print("Berhasil membuat surah_info.db!")
