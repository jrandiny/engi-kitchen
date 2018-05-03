unit UTipe;

interface
  const
    NMAX = 100;
    HARGAUPGRADE = 1000;

  type UserInput = record
    Perintah:string;
    Opsi1:string;
    Opsi2:string;
  end;

  type Tabel = record
    Isi : array[1..NMAX] of array[1..NMAX] of string;
    NKol : integer;
    NBar : integer;
  end;

  type Tanggal = record
    Hari : integer;
    Bulan : integer;
    Tahun : integer;
  end;

  type BahanMentah = record
    Nama:string;
    Harga:longint;
    Kadaluarsa:integer;
  end;

  type BahanOlahan = record
    Nama:string;
    Harga:longint;
    JumlahBahan:integer;
    Bahan:array[1..10] of string;
  end;

  type DaftarBahanMentah = record
    Isi:array[1..NMAX] of BahanMentah;
    Neff:integer;
  end;

  type DaftarBahanOlahan = record
    Isi:array[1..NMAX] of BahanOlahan;
    Neff:integer;
  end;

  type InventoriBahanMentah = record
    Isi:array[1..NMAX] of BahanMentah;
    Jumlah:array[1..NMAX] of integer;
    TanggalBeli:array[1..NMAX] of Tanggal;
    Total:integer;
    Neff:integer;
  end;

  type InventoriBahanOlahan = record
    Isi:array[1..NMAX] of BahanOlahan;
    Jumlah:array[1..NMAX] of integer;
    TanggalBuat:array[1..NMAX] of Tanggal;
    Total:integer;
    Neff:integer;
  end;

  type Resep = record
    Nama:string;
    Harga:longint;
    JumlahBahan:integer;
    Bahan:array[1..20] of string;
  end;

  type DaftarResep = record
    Isi:array[1..NMAX]of Resep;
    Neff:integer;
  end;

  type Simulasi = record
    Nomor:integer;
    Tanggal:Tanggal;
    JumlahHidup:integer;
    Energi:integer;
    Kapasitas:integer;
    BeliMentah:integer;
    BuatOlahan:integer;
    JualOlahan:integer;
    JualResep:integer;
    Pemasukan:longint;
    Pengeluaran:longint;
    TotalUang:longint;
  end;

  type DaftarSimulasi = record
    Isi:array[1..NMAX]of Simulasi;
    Neff:integer;
  end;

implementation

end.
