program TestResep;

uses UResep,UInventori,UFile,UTipe,USimulasi,UTanggal;

var
  input:string;
  isError:boolean;
  inputResep:Resep;
  j:integer;

begin
  writeln('TESTING UResep');
  writeln();

  write('Uang : ');
  readln(SimulasiAktif.TotalUang);
  write('inventori : ');
  readln(SimulasiAktif.Kapasitas);
  write('Tanggal : ');
  readln(input);
  SimulasiAktif.Tanggal := getTanggal(input);

  writeln('LOAD');
  DaftarBahanM := getBahanMentah(parse('bahan_mentah.txt'));
  DaftarBahanO := getBahanOlahan(parse('bahan_olahan.txt'));
  InventoriO := getInventoriBahanOlahan(parse('inventori_bahan_olahan_1.txt'));
  InventoriM := getInventoriBahanMentah(parse('inventori_bahan_mentah_1.txt'));
  ResepResep := getResep(parse('resep.txt'));

  while(true)do
  begin
    writeln();
    writeln('TESTING - UResep');
    write('Perintah : ');
    readln(input);

    case input of
      'lihat':begin
        lihatResep();
      end;
      'sort':begin
        sortResep();
      end;
      'tambah':begin
        write('Nama : ');
        readln(inputResep.Nama);
        write('Harga : ');
        readln(inputResep.Harga);
        write('Jumlah bahan : ');
        readln(inputResep.JumlahBahan);
        for j:=1 to inputResep.JumlahBahan do
        begin
          write('Bahan 1 : ');
          readln(inputResep.Bahan[j]);
        end;
        tambahResep(inputResep,isError);
      end;
      'jual':begin
        write('Nama resep : ')
        readln(input);
        SimulasiAktif.TotalUang:=SimulasiAktif.TotalUang + jualResep(input)+1;
        writeln('Uang sekarang : ' , SimulasiAktif.TotalUang);
      end;
      'inventori':begin
        lihatInventori();
      end;
      'cari':begin
        writeln('Nama resep : ')
        readln(input);
        cariResep(input);
      end;
      'uang':begin
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
        write('Uang : ');
        readln(SimulasiAktif.TotalUang);
        writeln('Uang sekarang : ',SimulasiAktif.TotalUang);
      end;
      'exit':begin
        break;
      end;
      'help':begin
        writeln('cari      -> Cari resep');
        writeln('exit      -> Keluar');
        writeln('inventori -> Menampilkan inventori');
        writeln('jual      -> Membuat dan menjual resep');
        writeln('lihat     -> Melihat resep');
        writeln('sort      -> Mengurutkan resep berdasarkan abjad');
        writeln('uang      -> Mengatur uang');
      end;


    end;
  end;

end.
