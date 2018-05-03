program TestInventori;

uses UInventori,UFile,UTipe,USimulasi,UTanggal;

var
  isAda:boolean;
  input:string;
  isError:boolean;
  JumlahBeli:integer;
  JumlahJual:integer;

begin
  writeln('TESTING UInventori');
  writeln();

  write('Uang : ');
  readln(SimulasiAktif.TotalUang);
  write('inventori : ');
  readln(SimulasiAktif.Kapasitas);

  writeln('LOAD');
  DaftarBahanM := getBahanMentah(parse('bahan_mentah.txt'));
  DaftarBahanO := getBahanOlahan(parse('bahan_olahan.txt'));
  InventoriO := getInventoriBahanOlahan(parse('inventori_bahan_olahan.txt'));
  InventoriM := getInventoriBahanMentah(parse('inventori_bahan_mentah.txt'));
  while(true)do
  begin
    writeln();
    writeln('Test Station');
    write('command : ');
    readln(input);

    case input of
      'ada':begin
        writeln();
        writeln('TESTING isBahanAda');
        writeln();

        write('Bahan yang mau dicek : ');
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

        readln(input);
        readln(JumlahBeli);
        beliBahan(input, JumlahBeli, isError);
        if (isError) then
        begin
          writeln('ERROR');
        end else
        begin
          writeln('SUKSES');
        end;
      end;
      'uang':begin
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
        write('Uang : ');
        readln(SimulasiAktif.TotalUang);
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
      end;
      'jualO':begin
        writeln();
        writeln('TESTING jualOlahan');
        writeln();

        writeln('Jumlah Uang adalah : ' , SimulasiAktif.TotalUang);
        writeln();
        write('Masukan olahan yang ingin dijual : '); readln(input);
        write('Masukan JumlahJual : '); readln(JumlahJual);
        SimulasiAktif.TotalUang := SimulasiAktif.TotalUang + jualOlahan(input, JumlahJual);
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
        write('Masukan bahan yang ingin dikurang : '); readln(input);
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
        write('Masukan bahan yang ingin diolah : '); readln(input);
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
        writeln('kapasitas : ', SimulasiAktif.Kapasitas);
        write('inventori : ');
        readln(SimulasiAktif.Kapasitas);

      end;
      'total':begin
        writeln();
        writeln('total mentah : ', InventoriM.Total);
        writeln('total olahan : ', inventoriO.Total);
      end;

    end;
  end;

end.
