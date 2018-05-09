# DAFTAR COMMAND

## Help

Command yang harus dijalankan jika ingin melihat daftar perintah yang diingini.

```
> help
```

## Load

Command yang harus dijalankan pertama kali program dibuka agar dapat menggunakan command-command lain. Ketika dijalankan, akan mengambil data yang tersimpan dari file eksternal dan disimpan dalam variabel sementara dalam program utama. Data tersebut akan digunakan untuk menjalankan simulasi-simulasi. Cara menggunakan command ini adalah:

```
> load
```

## Exit

Command yang ketika dijalankan akan menyimpan semua data baru hasil simulasi ke dalam suatu file eksternal. Setelah selesai menyimpan data, akan langsung keluar dari program. Command ini hanya bisa dijalankan ketika simulasi sedang tidak berjalan. Cara menggunakan command ini adalah:

```
> exit
```

## Start simulasi

Command yang berfungsi untuk memulai suatu nomor simulasi. Command ini hanya bisa dijalankan ketika simulasi sedang tidak berjalan. Cara menjalankan command ini ada dua cara, yaitu:

```
> start nomor_simulasi
```

atau

```
> start
Nomor simulasi: nomor_simulasi
```

dengan nomor_simulasi adalah sebuah integer yang merupakan nomor simulasi yang ingin dijalankan. nomor_simulasi haruslah nomor simulasi yang sudah terdaftar.

## Lihat inventori

Command untuk melihat daftar inventori dari suatu simulasi. Command ini dapat dijalankan ketika simulasi sedang berjalan ataupun tidak.
Ketika simulasi sedang tidak berjalan, cara-cara menggunakan command ini adalah:

```
> lihatinventori nomor_simulasi
```

atau

```
> lihatinventori
Nomor inventori: nomor_simulasi
```

dengan nomor_simulasi adalah sebuah integer yang merupakan nomor simulasi dari inventori yang ingin ditampilkan.
Ketika simulasi sedang berjalan, cara menggunakan command ini adalah:

```
>> lihatinventori
```

Tidak perlu menambahkan nomor_simulasi, karena akan langsung menampilkan inventori dari simulasi yang sedang berjalan.

## Stop

Command untuk menghentikan simulasi yang sedang berjalan. Command ini hanya dapat dijalankan ketika simulasi sedang berjalan. Setelah command ini dijalankan, pengguna dapat menjalankan command-command yang dapat berjalan di luar simulasi. Cara menggunakan command ini adalah:

```
> stop
```

## Beli bahan

Command digunakan untuk membeli bahan. Command ini hanya dapat berjalan ketika simulasi sedang berjalan. Cara menggunakannya adalah:

```
>> belibahan nama_bahan jumlah_bahan
```

atau

```
>> belibahan nama_bahan
Jumlah bahan: jumlah_bahan
```

atau

```
>> belibahan
Nama bahan: nama_bahan
Jumlah bahan: jumlah_bahan
```

dengan nama_bahan adalah nama bahan yang akan dibeli, dan jumlah_bahan adalah integer yang merupakan banyaknya bahan tersebut yang ingin dibeli. Command hanya akan berjalan jika nama_bahan terdaftar, sisa kapasitas inventori cukup, dan Chef memiliki energi dan uang yang cukup. Khusus untuk cara penggunaan pertama dan kedua, nama_bahan tidak boleh lebih dari satu kata. Jika nama bahan lebih dari satu kata, gunakan cara penggunaan ketiga.

## Olah bahan

Command untuk menghasilkan bahan olahan dari bahan mentah. Command hanya dapat berjalan ketika simulasi sedang berjalan. Cara menggunakannya adalah:

```
>> olahbahan nama_bahan_olahan
```

atau

```
>> olahbahan
Nama bahan olahan: nama_bahan_olahan
```

dengan nama_bahan_olahan merupakan nama bahan olahan yang ingin dihasilkan. Command hanya dapat berjalan jika nama_bahan_olahan terdaftar, bahan mentah yang dibutuhkan tersedia dalam inventori, dan Chef memiliki energi yang cukup. Cara penggunaan pertama hanya bisa jika nama_bahan_olahan terdiri dari satu kata. Jika lebih, gunakan cara kedua.

## Jual olahan

Command bertujuan untuk menjual bahan olahan. Command hanya dapat berjalan ketika simulasi berjalan. Cara menggunakan command ini adalah:

```
>> jualolahan nama_bahan_olahan jumlah_bahan_olahan
```

atau

```
>> jualolahan nama_bahan_olahan
Jumlah bahan olahan untuk dijual: jumlah_bahan_olahan
```

atau

```
>> jualolahan
Nama bahan olahan: nama_bahan_olahan
Jumlah bahan olahan: jumlah_bahan_olahan
```

dengan nama_bahan_olahan adalah nama bahan olahan yang akan dijual, dan jumlah_bahan_olahan adalah integer yang merupakan banyak bahan olahan yang ingin dijual. Penjualan bahan olahan hanya dapat terjadi jika nama_bahan_olahan terdapat dalam inventori dengan jumlah yang cukup, dan Chef memiliki energi yang cukup. Untuk cara pertama dan kedua, nama_bahan_olahan harus terdiri atas satu kata. Jika lebih, gunakan cara ketiga.

## Jual resep

Command untuk membuat dan menjual hidangan yang dibuat sesuai resep. Command hanya dapat berjalan ketika simulasi sedang berjalan. Cara penggunaan command ini adalah:

```
>> jualresep nama_resep
```

atau

```
>> jualresep
Nama resep: nama_resep
```

dengan nama_resep adalah nama dari hidangan yang akan dihasilkan dan dijual. Penjualan hanya dapat terjadi jika nama_resep sudah terdaftar, semua bahan olahan maupun bahan mentah yang dibutuhkan tersedia dalam inventori, dan Chef memiliki energi yang cukup.

## Pengisian energi Chef

Terdapat tiga cara untuk menambah energi Chef, yaitu dengan makan, istirahat dan tidur. Cara menggunakan masing-masing command ini adalah:

```
>> makan
>> istirahat
>> tidur
```

Satu kali makan akan menambah tiga energi. Satu kali istirahat akan menambah satu energi. Dalam hari yang sama, makan hanya dapat dilakukan sebanyak tiga kali, dan istirahat hanya dapat dilakukan sebanyak enam kali. Jika tidur, energi akan bertambah sampai 10 dan terjadi pergantian hari. Command tidur hanya dapat terjadi jika minimal satu energi telah terpakai setelah tidur yang sebelumnya. Energi maksimum yang dapat dimiliki Chef adalah 10. Command-command tersebut hanya dapat dijalankan ketika simulasi sedang berjalan.

## Lihat statistik

Command ini berfungsi untuk menampilkan data simulasi. Command ini hanya dapat dijalankan ketika simulasi sedang berjalan. Cara penggunaannya adalah:

```
>> lihatstatistik
```

atau

```
>> statistik
```

## Lihat resep

Command ini akan menampilkan nama semua resep yang ada beserta harga, jumlah bahan, dan daftar bahan masing-masing resep. Command dapat dijalankan di dalam maupun di luar simulasi. Cara penggunaannya adalah:

```
> lihatresep
```

## Cari resep

Command ini berfungsi untuk mencari suatu resep tertentu. Command ini dapat dijalankan baik di luar maupun di dalam simulasi. Cara menggunakannya adalah:

```
> cariresep nama_resep
```

atau

```
>> cariresep
Nama resep: nama_resep
```

dengan nama_resep adalah nama resep yang ingin dicari. Command akan berhasil dijalankan jika nama_resep sudah terdaftar. Cara pertama hanya dapat digunakan jika nama_resep terdiri atas satu kata. Jika lebih, gunakan cara kedua.

## Tambah resep

Command ini berfungsi untuk menambahkan resep baru. Command dapat berjalan baik di dalam maupun di luar simulasi. Cara menggunakannya adalah:

```
>> tambahresep nama_resep
Harga: harga_resep
Jumlah bahan: jumlah_bahan
Daftar bahan:
  1. nama_bahan_1
  2. nama_bahan_2
  .
  .
```

atau

```
> tambahresep
Nama resep: nama_resep
Harga: harga_resep
Jumlah bahan: jumlah_bahan
Daftar bahan:
  1. nama_bahan_1
  2. nama_bahan_2
  .
  .
```

dengan nama_resep adalah nama resep yang akan ditambahkan, harga_resep adalah harga jual makanan yang dihasilkan berdasarkan resep tersebut, jumlah_bahan adalah banyaknya bahan pembentuk resep, dan nama_bahan adalah nama bahan-bahan resep tersebut dengan jumlah sebanyak jumlah_bahan. Penambahan resep hanya akan berhasil jika nama_bahan adalah nama bahan-bahan yang sudah terdaftar. Untuk cara pertama, nama_resep harus terdiri dari satu kata. Jika lebih, gunakan cara kedua.

## Upgrade inventori

Command untuk menambah kapasitas maksimum inventori. Command dapat berjalan ketika simulasi sedang berjalan maupun tidak, akan tetapi Chef harus memiliki uang yang cukup. Cara menggunakan command ini adalah:

```
>> upgradeinventori
```
