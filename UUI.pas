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

  procedure tanya(prompt:string;var jawaban:string);
  {I.S. : terdefinisi prompt dan variabel jawaban}
  {F.S. : Mengembalikan hasil jawaban dari user}

  procedure commandPredictor(input:string;Daftar:DaftarPerintah);
  {I.S. : Terdefinisi perintah-perintah yang mungkin}
  {F.S. : Dicetak ke layar command yang paling mirip}

  procedure formatUserInput(var Diketik:string);
  {I.S. : terdefinisi input Diketik}
  {F.S. : Mengubah menjadi format ProperCase}

  function bacaInput(Input:string):UserInput;
  {memecah Input ke perintah, opsi1,opsi2,dst}

implementation

  procedure formatUserInput(var Diketik:string);
  {I.S. : terdefinisi input Diketik}
  {F.S. : Mengubah menjadi format ProperCase}

  var
    n: integer;
  begin
    if (length(Diketik) > 0) then
    begin
      Diketik[1] := UpCase(Diketik[1]);
      n := 2;
      while (n <= length(Diketik)) do
      begin
        Diketik[n] := LowerCase(Diketik[n]);
        if (Diketik[n] = ' ') then
        begin
          Diketik[n+1] := UpCase(Diketik[n+1]);
          n := n + 2;
        end else
        begin
          n := n + 1;
        end;
      end;
    end;
  end;

  function bacaInput(Input:string):UserInput;
  {memecah Input ke perintah, opsi1, dan opsi2}

  {Kamus lokal}
  var
    i: integer;
    Indeks: integer;
    Sementara: string;
    Hasil:UserInput;
    Separator:char;

  {Algoritma}
  begin
    Sementara:= '';
    i:=1;
    Indeks:=1;
    Hasil.Perintah := '';
    Hasil.Neff:=0;
    Separator:=' ';

    {Looping semua input}
    while (i<=length(Input)) do
    begin

      {Jika separator, data biasa, atau habis}
      if ((Input[i]='"')and(Separator=' '))then
      begin
        Separator:='"';
      end else if ((Input[i]=Separator) or (i=length(Input))) then
      begin

        {Jika habis langsung tambahkan input terakhir}
        if(i=length(Input))then
        begin
          {tambahkan kecuali jika "}
          if (Separator<>'"')then
          begin
            Sementara := Sementara + Input[i];
          end;
        end;

        {Masukkan ke tempat yang benar}
        if (Indeks=1)then
        begin
          Hasil.Perintah:=Sementara;
        end else
        begin
          Hasil.Neff:=Hasil.Neff+1;
          Hasil.Opsi[Hasil.Neff]:=Sementara;
        end;

        Indeks:=Indeks+1;
        Sementara:='';

        {Skip satu jika separator menggunakan "}
        if (Separator='"')then
        begin
          Separator:=' ';
          i:=i+1;
        end;

      end else
      begin
        Sementara:=Sementara + Input[i];
      end;

      i:=i+1;

    end;

    bacaInput:=Hasil;
  end;

  procedure commandPredictor(input:string;Daftar:DaftarPerintah);
  {I.S. : Terdefinisi perintah-perintah yang mungkin}
  {F.S. : Dicetak ke layar command yang paling mirip}

  {KAMUS LOKAL}
  const
    MINCOCOK=0.49;

  var
    Kecocokan : real;
    i,j:integer;
    Total:integer;
    Sama:integer;
    MaxCocok:real;
    IndeksCocok:array[1..NMAX]of integer;
    Neff:integer;

  begin

    {search}
    MaxCocok:=MINCOCOK;
    Neff:=1;
    for i:=1 to Daftar.Neff do
    begin
      sama:=0;
      total:=Length(input);
      for j:=1 to total do
      begin
        {Jika panjang input lebih dari perintah, dianggap ketidaksesuain}
        if(j<=Length(Daftar.Isi[i]))then
        begin
          {Jika huruf sama, tambah kesesuaian}
          if(Daftar.Isi[i][j]=input[j])then
          begin
            sama:=sama+1;
          end;
        end;
      end;

      {Cari persentase kesesuaian}
      Kecocokan:=sama/total;
      if(Kecocokan>MaxCocok)then
      begin
        MaxCocok:=Kecocokan;
        IndeksCocok[Neff]:=i;
      end;
    end;

    {Output yang cocok}
    if((MaxCocok-MINCOCOK)>0.0001)then
    begin
      writelnText('Mungkin yang dimaksud :');
      for i:=1 to Neff do
      begin
        writelnText(Daftar.Isi[IndeksCocok[i]]);
      end;
    end;

  end;

  procedure tanya(prompt:string;var jawaban:string);
  {I.S. : terdefinisi prompt dan variabel jawaban}
  {F.S. : Mengembalikan hasil jawaban dari user}
  begin
    write(prompt,' : ');
    readln(jawaban);
  end;

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
