program TestFile;

uses UFile,UTipe;

  {KAMUS}
var
  i:integer;
  j:integer;

  sementara:Tabel;
  test: DaftarBahanMentah;
  test2:DaftarBahanOlahan;
  test3:DaftarSimulasi;
  test4:DaftarResep;
  test5:InventoriBahanMentah;
  test6:InventoriBahanOlahan;

begin
  writeln('START TESTING');
  writeln();

  writeln('START TESTING getBahanMentah');
  writeln();

  sementara:=parse('bahan_mentah.txt');
  test := getBahanMentah(sementara);
  for i:=1 to test.Neff do
  begin
    write(test.Isi[i].Nama);
    write(' | ');
    write(test.Isi[i].Harga);
    write(' | ');
    write(test.Isi[i].Kadaluarsa);
    writeln();
  end;

  writeln();

  writeln('START TESING getBahanOlahan');
  writeln();

  test2:=getBahanOlahan(parse('bahan_olahan.txt'));
  for i:=1 to test2.Neff do
  begin
    write(test2.Isi[i].Nama);
    write(' | ');
    write(test2.Isi[i].Harga);
    write(' | ');
    write(test2.Isi[i].JumlahBahan);

    for j:=1 to test2.Isi[i].JumlahBahan do
    begin
      write(' | ');
      write(test2.Isi[i].Bahan[j]);
    end;
    writeln();
  end;

  writeln();

  writeln('START TESING getInventoriBahanMentah');
  writeln();

  test5:=getInventoriBahanMentah(parse('inventori_bahan_mentah.txt'));
  for i:=1 to test5.Neff do
  begin
    write(test5.Isi[i].Nama);
    write('(');
    write(test5.Isi[i].Nama);
    write(' | ');
    write(test5.Isi[i].Harga);
    write(' | ');
    write(test5.Isi[i].Kadaluarsa);
    write(')');
    write(' | ');
    write(test5.TanggalBeli[i].Hari);
    write('/');
    write(test5.TanggalBeli[i].Bulan);
    write('/');
    write(test5.TanggalBeli[i].Tahun);
    write(' | ');
    write(test5.Jumlah[i]);
    writeln();
  end;

  writeln();

  writeln('START TESING getInventoriBahanOlahan');
  writeln();

  test6:=getInventoriBahanOlahan(parse('inventori_bahan_olahan.txt'));
  for i:=1 to test6.Neff do
  begin
    write(test6.Isi[i].Nama);
    write('(');
    write(test6.Isi[i].Nama);
    write(' | ');
    write(test6.Isi[i].Harga);
    write(' | ');
    write(test6.Isi[i].JumlahBahan);
    for j:=1 to test6.Isi[i].JumlahBahan do
    begin
      write(' | ');
      write(test6.Isi[i].Bahan[j]);
    end;
    write(')');
    write(' | ');
    write(test6.TanggalBuat[i].Hari);
    write('/');
    write(test6.TanggalBuat[i].Bulan);
    write('/');
    write(test6.TanggalBuat[i].Tahun);
    write(' | ');
    write(test6.Jumlah[i]);
    writeln();
  end;

  writeln();

  writeln('START TESING getResep');
  writeln();

  test4:=getResep(parse('resep.txt'));
  for i:=1 to test4.Neff do
  begin
    write(test4.Isi[i].Nama);
    write(' | ');
    write(test4.Isi[i].Harga);
    write(' | ');
    write(test4.Isi[i].JumlahBahan);

    for j:=1 to test4.Isi[i].JumlahBahan do
    begin
      write(' | ');
      write(test4.Isi[i].Bahan[j]);
    end;
    writeln();
  end;

  writeln();

  writeln('START TESTING getSimulasi');
  writeln();

  test3:=getSimulasi(parse('simulasi.txt'));
  for i:=1 to test3.Neff do
  begin
    write(test3.Isi[i].Nomor);
    write(' | ');
    write(test3.Isi[i].Tanggal.Hari);
    write('/');
    write(test3.Isi[i].Tanggal.Bulan);
    write('/');
    write(test3.Isi[i].Tanggal.Tahun);
    write(' | ');
    write(test3.Isi[i].JumlahHidup);
    write(' | ');
    write(test3.Isi[i].Energi);
    write(' | ');
    write(test3.Isi[i].Kapasitas);
    write(' | ');
    write(test3.Isi[i].BeliMentah);
    write(' | ');
    write(test3.Isi[i].BuatOlahan);
    write(' | ');
    write(test3.Isi[i].JualOlahan);
    write(' | ');
    write(test3.Isi[i].JualResep);
    write(' | ');
    write(test3.Isi[i].Pemasukan);
    write(' | ');
    write(test3.Isi[i].Pengeluaran);
    write(' | ');
    write(test3.Isi[i].TotalUang);

    writeln();

  end;

  writeln('TESTING WRITING BACK');

  tulisBalik(test,test2,test5,test6,test4,test3);







end.
