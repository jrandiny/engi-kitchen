program TestTanggal;

uses UTanggal,UTipe;

var
  input:string;
  x,y:Tanggal;

begin
  writeln('TANGGAL TESTER');
  writeln();

  while(true)do
  begin
    write('command : ');
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
        y:=nextTanggal(x);
        writeln(y.Hari, y.Bulan, y.Tahun);
      end;
    end;
  end;

end.
