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
  readText(a);
  writelnText(a);

  Input.Isi[1][1]:='KOLOM 1';
  Input.Isi[1][2]:='KOLOM 2';
  Input.Isi[1][3]:='KOLOM 3';
  Input.Isi[2][1]:='abc';
  Input.Isi[2][2]:='asjsdajsajlkasdjksa';
  Input.Isi[2][3]:='jojojojo';
  Input.Isi[3][1]:='abc';
  Input.Isi[3][2]:='asjsdajsajlkasdjksa';
  Input.Isi[3][3]:='jojojojo';
  Input.Isi[4][1]:='abc';
  Input.Isi[4][2]:='asjsdajsajlkasdjksa';
  Input.Isi[4][3]:='jojojojo';
  Input.Isi[5][1]:='abc';
  Input.Isi[5][2]:='asjsdajsajlkasdjksa';
  Input.Isi[5][3]:='jojojojo';

  Input.NBar:=5;
  Input.NKol:=5;

  Ukuran.Kolom:=3;
  Ukuran.Ukuran[1]:=10;
  Ukuran.Ukuran[2]:=20;
  Ukuran.Ukuran[3]:=15;

  writeTabel(Input,Ukuran,'CONTOH TABEL');

end.
