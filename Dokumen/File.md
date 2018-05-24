# File

## Format Nama

File ditulis dalam format txt dengan nama-nama sebagai berikut :

- bahan_mentah.txt
- bahan_olahan.txt
- resep.txt
- simulasi.txt

Untuk inventori ditulis dengan format sebagai berikut :

- inventori_bahan_mentah_[X].txt
- inventori_bahan_olahan_[X].txt

dengan [X] diisi oleh nomor inventori. Misal:
- inventori_bahan_mentah_1.txt
- inventori_bahan_olahan_1.txt

## Format Isi

Yang perlu diperhatikan :
- Penulisan isi dipisahkan dengan guard ( | )
- Penulisan nama mengunakan huruf kapital di setiap awal kata (misal : Nasi Goreng)

### Bahan Mentah
```
Nama Bahan Mentah | Harga Satuan | Durasi Kadaluarsa
```

### Bahan Olahan
```
Nama Bahan Olahan | Harga Jual | N | Bahan-1 | Bahan-2 | Bahan-3 | … | Bahan-N
```
Dengan 1<=N<=10

### Inventori Bahan Mentah
```
Nama Bahan Mentah | Tanggal Beli | Jumlah
```

### Inventori Bahan Olahan
```
Nama Bahan Olahan | Tanggal Buat | Jumlah
```

### Resep
```
Nama Resep | Harga Jual | N | Bahan-1 | Bahan-2 | Bahan-3 | … | Bahan-N
```
Dengan 2<=N<=20

### Simulasi
```
Nomor Simulasi | Tanggal | Jumlah Hari Hidup | Jumlah Energi | Kapasitas Maksimum
Inventori | Total Bahan Mentah Dibeli | Total Bahan Olahan Dibuat | Total Bahan
Olahan Dijual | Total Resep Dijual | Total Pemasukan | Total Pengeluaran | Total
Pendapatan
```
