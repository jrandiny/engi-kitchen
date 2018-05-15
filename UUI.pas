unit UUI;

interface

  uses UTipe;

  procedure writeError(asal : string; pesan : string);
  {Mengoutput pesan error}
  {I.S. : Terdefinisi pesan error dan asal pesan}
  {F.s. : Tercetak di layar pesan error}

  procedure writeLog(asal : string; pesan : string);
  {Mengoutput log}
  {I.S. : Terdefinisi pesan dan asal pesan}
  {F.S. : Terdetak di layar logging}

  procedure writeText(pesan:string);
  {Mengoutput teks}
  {I.S. : Terdefinisi pesan}
  {F.S. : Tercetak pesan}

  procedure writelnText(pesan:string);
  {Mengoutput teks}
  {I.S. : Terdefinisi pesan}
  {F.S. : Tercetak pesan diikuti new line}

  procedure readText(var pesan:string);
  {Membaca teks}
  {I.S. : diminta input}
  {F.S. : input ditaruh di pesan}

  procedure prompt(var Diketik:string; isSimulasiAktif:boolean);
  {I.S. : isSimulasiAktif terdefinisi}
  {F.S. : variabel userInput yang menyimpan masukan command dari pengguna terisi}



implementation

  procedure prompt(var Diketik:string; isSimulasiAktif:boolean);
  {I.S. : isSimulasiAktif terdefinisi}
  {F.S. : variabel userInput yang menyimpan masukan command dari pengguna terisi}
  begin
    if (isSimulasiAktif = false) then
    begin
      write('> ');
      readln(Diketik);
    end else
    begin
      write('>> ');
      readln(Diketik);
    end;
  end;

  procedure writeError(asal : string; pesan : string);
  {Mengoutput pesan error}
  {I.S. : Terdefinisi pesan error dan asal pesan}
  {F.s. : Tercetak di layar pesan error}

  {Algoritma - writeError}
  begin
    write('ERROR : ');
    write(asal);
    write(' -> ');
    writeln(pesan);
  end;

  procedure writeLog(asal : string; pesan : string);
  {Mengoutput log}
  {I.S. : Terdefinisi pesan dan asal pesan}
  {F.S. : Terdetak di layar logging}

  {Algoritma - writeLog}
  begin
    write('LOG : ');
    write(asal);
    write(' -> ');
    writeln(pesan);
  end;

  procedure writeText(pesan:string);
  {Mengoutput teks}
  {I.S. : Terdefinisi pesan}
  {F.S. : Tercetak pesan}

  {Algoritma - writeText}
  begin
    write(pesan);
  end;

  procedure writelnText(pesan:string);
  {Mengoutput teks}
  {I.S. : Terdefinisi pesan}
  {F.S. : Tercetak pesan diikuti new line}

  {Algoritma - writelnText}
  begin
    writeln(pesan);
  end;

  procedure readText(var pesan:string);
  {Membaca teks}
  {I.S. : diminta input}
  {F.S. : input ditaruh di pesan}

  {Algoritma - readText}
  begin
    readln(pesan);
  end;

end.
