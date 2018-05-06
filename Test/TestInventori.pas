program TestInventori;

uses UInventori,UFile,UTipe,USimulasi,UTanggal;

var
  isAda:boolean;
  input:string;
  isError:boolean;
  JumlahBeli:integer;
  JumlahJual:integer;
  DeltaUang:longint;

begin
  writeln('TESTING - UInventori');
  writeln();

  write('Uang : ');
  readln(SimulasiAktif.TotalUang);
  write('Kapasitas inventori : ');
  readln(SimulasiAktif.Kapasitas);
  write('Tanggal : ');
  readln(input);
  SimulasiAktif.Tanggal := getTanggal(input);

  writeln('LOAD');
  DaftarBahanM := getBahanMentah(parse('bahan_mentah.txt'));
  DaftarBahanO := getBahanOlahan(parse('bahan_olahan.txt'));
  InventoriO := getInventoriBahanOlahan(parse('inventori_bahan_olahan_1.txt'));
  InventoriM := getInventoriBahanMentah(parse('inventori_bahan_mentah_1.txt'));
  while(true)do
  begin
    writeln();
    writeln('TESTING - UInventori');
    write('Perintah : ');
    readln(input);

    case input of
      'ada':begin
        writeln();
        writeln('TESTING isBahanAda');
        writeln();

        write('Nama bahan : ');
        readln(input);
        isAda := isBahanAda(input);
        if(isAda)then
        begin
          writeln(input, ' ADA');
        end else
        begin
          writeln(input, ' TIDAK ADA');
        end;
      end;
      'beli':begin
        writeln();
        writeln('TESTING beliBahan');
        writeln();

        write('Nama bahan : ');
        readln(input);
        write('Jumlah : ');
        readln(JumlahBeli);
        DeltaUang := beliBahan(input, JumlahBeli);
        if (DeltaUang=-1) then
        begin
          writeln('ERROR');
        end else
        begin
          SimulasiAktif.TotalUang:=SimulasiAktif.TotalUang-DeltaUang-1;
          writeln('SUKSES');
        end;
      end;
      'uang':begin
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
        write('Uang : ');
        readln(SimulasiAktif.TotalUang);
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
      end;
      'jual':begin
        writeln();
        writeln('TESTING jualOlahan');
        writeln();

        writeln('Jumlah Uang adalah : ' , SimulasiAktif.TotalUang);
        writeln();
        write('Nama olahan : '); readln(input);
        write('Jumlah yang ingin dijual : '); readln(JumlahJual);
        SimulasiAktif.TotalUang := SimulasiAktif.TotalUang + jualOlahan(input, JumlahJual) +1;
        writeln('Jumlah Uang adalah ' , SimulasiAktif.TotalUang);
      end;
      'exit':begin
        break;
      end;
      'lihat':begin
        lihatInventori();
      end;
      'kurang':begin
        writeln();
        writeln('TESTING kuranginBahan');
        writeln();
        write('Nama bahan : '); readln(input);
        kuranginBahan(input, isError);
        if (isError) then
        begin
          writeln('ERROR');
        end else
        begin
          writeln('SUKSES');
        end;
      end;
      'kadaluarsa':begin
        writeln();
        writeln('TESTING hapusKadaluarsa');
        writeln();
        write('Tanggal : ');
        readln(input);
        SimulasiAktif.Tanggal := getTanggal(input);
        hapusKadaluarsa()
      end;
      'upgrade':begin
        writeln();
        writeln('TESTING upgradeInventori');
        writeln();
        upgradeInventori(isError);
      end;
      'sort':begin
        writeln();
        writeln('TESTING sortArray');
        writeln();
        sortArray();
      end;
      'olah':begin
        writeln();
        writeln('TESTING olahBahan');
        writeln();
        write('Nama olahan : '); readln(input);
        olahBahan(input, isError);
        if (isError) then
        begin
          writeln('ERROR');
        end else
        begin
          writeln('SUKSES');
        end;
      end;
      'kapasitas':begin
        writeln();
        writeln('Kapasitas sekarang : ', SimulasiAktif.Kapasitas);
        write('Kapasitas yang diingini : ');
        readln(SimulasiAktif.Kapasitas);

      end;
      'total':begin
        writeln();
        writeln('Total mentah : ', InventoriM.Total);
        writeln('Total olahan : ', inventoriO.Total);
      end;
      'help':begin
        writeln('ada        -> Cek apakah sebuah bahan ada');
        writeln('beli       -> Beli bahan mentah');
        writeln('exit       -> Keluar');
        writeln('jual       -> Jual bahan olahan');
        writeln('kadaluarsa -> Menghapus bahan kadaluarsa');
        writeln('kapasitas  -> Mengubah kapasitas inventori sekarang');
        writeln('kurang     -> Mengurangi bahan sebanyak 1');
        writeln('lihat      -> Menampilkan inventori');
        writeln('olah       -> Mengolah bahan olahan');
        writeln('sort       -> Sorting inventori bedasarkan abjad');
        writeln('total      -> Menampilkan total inventori');
        writeln('uang       -> Set uang');
        writeln('upgrade    -> Upgrade kapasitas inventori');

      end;

    end;
  end;

end.
