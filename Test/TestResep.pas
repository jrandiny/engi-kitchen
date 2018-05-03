program TestResep;

uses UResep,UInventori,UFile,UTipe,USimulasi,UTanggal;

var
  input:string;
  isError:boolean;
  inputResep:Resep;
  i,j:integer;

begin
  writeln('TESTING UResep');
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
  ResepResep := getResep(parse('resep.txt'));

  while(true)do
  begin
    writeln();
    writeln('Test Station');
    write('command : ');
    readln(input);

    case input of
      'lihatr':begin
        lihatResep();
      end;
      'sort':begin
        sortResep();
      end;
      'tambah':begin
        readln(inputResep.Nama);
        readln(inputResep.Harga);
        readln(inputResep.JumlahBahan);
        for j:=1 to inputResep.JumlahBahan do
        begin
          readln(inputResep.Bahan[j]);
        end;
        tambahResep(inputResep);
      end;
      'jual':begin
        readln(input);
        SimulasiAktif.TotalUang:=SimulasiAktif.TotalUang + jualResep(input);
        writeln('Jumlah Uang adalah ' , SimulasiAktif.TotalUang);
      end;
      'lihati':begin
        lihatInventori();
      end;
      'cari':begin
        readln(input);
        cariResep(input);
      end;
      'uang':begin
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
        write('Uang : ');
        readln(SimulasiAktif.TotalUang);
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
      end;


    end;
  end;

end.
