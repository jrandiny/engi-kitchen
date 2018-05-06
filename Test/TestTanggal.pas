program TestTanggal;

uses UTanggal,UTipe;

var
  input:string;
  x,y:Tanggal;

begin
  writeln('TESTING - UTanggal');
  writeln();

  while(true)do
  begin
    write('Perintah : ');
    readln(input);

    case input of
      'input1':begin
        write('Tanggal 1 : ');
        readln(input);
        x:=getTanggal(input);
      end;
      'input2':begin
        write('Tanggal 2 : ');
        readln(input);
        y:=getTanggal(input);
      end;
      'jarak':begin
        write('jarak : ');
        writeln(selisihTanggal(x,y));
      end;
      'sama':begin
        write('sama? : ');
        writeln(isTanggalSama(x,y));
      end;
      'duluan':begin
        write('1 duluan dari 2? :');
        writeln(isTanggalDuluan(x,y));
      end;
      'next':begin
        write(x.Hari,x.Bulan,x.Tahun,' -> ');
        y:=nextTanggal(x);
        writeln(y.Hari, y.Bulan, y.Tahun);
      end;
      'exit':begin
        break;
      end;
      'help':begin
        writeln('duluan -> Cek apakah tanggal 1 duluan dari tanggal 2');
        writeln('exit   -> Keluar');
        writeln('input1 -> Input tanggal 1');
        writeln('input2 -> Input tanggal 2');
        writeln('jarak  -> Menampilkan jarak(dalam hari) antara tanggal 1 dan 2');
        writeln('next   -> Memajukan tanggal 1 sebanyak 1 hari');
        writeln('sama   -> Cek apakah tanggal 1 dan 2 sama');
      end;
    end;
  end;

end.
