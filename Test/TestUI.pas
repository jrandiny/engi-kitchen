program TestUI;

uses UUI,UTipe;

var
  a:string;
  Input:Tabel;
  Ukuran:UkuranTabel;

begin
  writeError('TestUI','Testing writeError');
  writeLog('TestUI','Testing writeLog');
  writeText('Testing writeText');
  writelnText('Testing writelnText');
  writeText('Testing read : ');
  readText(a);
  writelnText(a);

  writelnText('Testing writeTabel');
  Input.Isi[1][1]:='KL 1 (10)';
  Input.Isi[1][2]:='KOLOM 2 (20)';
  Input.Isi[1][3]:='KOLOM 3 (15)';
  Input.Isi[2][1]:='data 1 1';
  Input.Isi[2][2]:='data 1 2';
  Input.Isi[2][3]:='data 1 3';
  Input.Isi[3][1]:='data 2 1';
  Input.Isi[3][2]:='data 2 2';
  Input.Isi[3][3]:='data 2 3';
  Input.Isi[4][1]:='data 3 1';
  Input.Isi[4][2]:='data 3 2';
  Input.Isi[4][3]:='data 3 3';
  Input.Isi[5][1]:='data 4 1';
  Input.Isi[5][2]:='data 4 2';
  Input.Isi[5][3]:='data 4 3';

  Input.NBar:=5;
  Input.NKol:=5;

  Ukuran.Kolom:=3;
  Ukuran.Ukuran[1]:=10;
  Ukuran.Ukuran[2]:=20;
  Ukuran.Ukuran[3]:=15;

  writeTabel(Input,Ukuran,'CONTOH TABEL');

end.
