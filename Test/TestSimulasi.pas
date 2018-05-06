Program testSimulasi;

uses USimulasi,UFile;

var
	IsError : boolean;
  Input:string;
  InputAngka:longint;
  InputAngka2:longint;
  IsJalan : boolean;

begin
	writeln('TESTING - USimulasi');
  writeln();

  writeln('LOAD');
  SemuaSimulasi := getSimulasi(parse('simulasi.txt'));
  IsJalan:=false;

  while(true)do
  begin
    writeln();
    writeln('TESTING - USimulasi');
    write('Perintah : ');
    readln(input);

    if(IsJalan)then
    begin
      case input of
        'makan':begin
          makan();
        end;
        'istirahat':begin
          istirahat()
        end;
        'tidur':begin
          tidur(IsError);
        end;
        'tambahUang':begin
          write('Jumlah penambahan : ');
          readln(InputAngka);
          tambahUang(InputAngka);
        end;
        'pakaiUang':begin
          write('Jumlah pengurangan : ');
          readln(InputAngka);
          pakaiUang(InputAngka,IsError);
        end;
        'lihat':begin
          lihatStatistik();
        end;
        'ubah':begin
          writeln('1 = jumlah mentah dibeli');
          writeln('2 = jumlah bahan diolah');
          writeln('3 = jumlah olahan dijual');
          writeln('4 = jumlah resep dijual}');
          write('Kode statistik : ');
          readln(InputAngka);
          write('Jumlah perubahan : ');
          readln(InputAngka2);
          ubahStatistik(InputAngka,InputAngka2);
        end;
      end;

    end else
    begin
      case input of
        'start':begin
          write('Nomor simulasi : ');
          readln(InputAngka);
          startSimulasi(InputAngka,IsError);
          if(not(IsError))then
          begin
            IsJalan:=true;
          end else
          begin
            IsJalan:=false;
          end;
        end;
      end;
    end;

    case input of
      'help':begin
        writeln('exit       -> Keluar');
        writeln('istirahat  -> Istirahat');
        writeln('lihat      -> Lihat statistik');
        writeln('makan      -> Makan');
        writeln('pakaiUang  -> Memakai uang');
        writeln('start      -> Memulai simulasi');
        writeln('tambahUang -> Menambahkan uang');
        writeln('tidur      -> Memulai hari baru');
        writeln('ubah       -> Ubah statistik');
      end;
      'exit':begin
        break;
      end;
    end;


  end;
end.
