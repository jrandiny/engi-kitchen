unit UFile;

interface

  uses UTipe,UTanggal;

  var
    LoadSukses:boolean;

  function parse(NamaFile:string):Tabel;
  {Menerima input nama file lalu output tabel sementara(data bentukan Tabel) berisi data dari file}

  function getBahanMentah(Input:Tabel):DaftarBahanMentah;
  {Menerima input tabel data sementara dan mengubahnya menjadi DaftarBahanMentah}

  function getBahanOlahan(Input:Tabel):DaftarBahanOlahan;
  {Menerima input tabel data sementara dan mengubahnya menjadi DaftarBahanOlahan}

  function getInventoriBahanMentah(Input:Tabel):InventoriBahanMentah;
  {Menerima input tabel data sementara dan mengubahnya menjadi InventoriBahanMentah}

  function getInventoriBahanOlahan(Input:Tabel):InventoriBahanOlahan;
  {Menerima input tabel data sementara dan mengubahnya menjadi InventoriBahanOlahan}

  function getResep(Input:Tabel):DaftarResep;
  {Menerima input tabel data sementara dan mengubahnya menjadi DaftarResep}

  function getSimulasi(Input:Tabel):DaftarSimulasi;
  {Menerima input tabel data sementara dan mengubahnya menjadi DaftarSimulasi}

  procedure tulisBalik(InputBahanMentah:DaftarBahanMentah; InputBahanOlahan:DaftarBahanOlahan; InputResep:DaftarResep; InputSimulasi:DaftarSimulasi);
  {I.S. : Menerima input ke 4 variabel daftar selain inventori}
  {F.S. : Semua variabel ditulis ke file}

  procedure tulisInventori(InputInventoriBahanMentah:InventoriBahanMentah; InputInventoriBahanOlahan:InventoriBahanOlahan;Nomor:integer);
  {I.S. : Menerima input 2 variabel inventori dan nomor simulasi inventori tersebut}
  {F.S. : dituliskan ke file}

implementation

  var
    InternalBahanMentah:DaftarBahanMentah;
    InternalBahanOlahan:DaftarBahanOlahan;

  function cariBahanMentah(Nama:string):integer;

  {Kamus Lokal}
  var
    i:integer;
    Ketemu:boolean;

  {Algoritma - cariBahanMentah}
  begin
    i:=1;
    Ketemu:=false;
    while ((i <= InternalBahanMentah.Neff)and not(Ketemu)) do
    begin
      if(InternalBahanMentah.Isi[i].Nama = Nama)then
      begin
        Ketemu := true;
      end else
      begin
        i:=i+1;
      end;
    end;
    if(not(Ketemu))then
    begin
      write('ERROR : UFile -> Ada entri inventori bahan mentah (');
      write(Nama);
      writeln(')  yang tidak punya entri di file bahan mentah');
      LoadSukses:=false;
    end;

    cariBahanMentah:=i;

  end;



  function cariBahanOlahan(Nama:string):integer;

  {Kamus Lokal}
  var
    i:integer;
    Ketemu:boolean;

  {Algoritma - cariBahanMentah}
  begin
    i:=1;
    Ketemu:=false;
    while ((i <= InternalBahanOlahan.Neff)and not(Ketemu)) do
    begin
      if(InternalBahanOlahan.Isi[i].Nama = Nama)then
      begin
        Ketemu := true;
      end else
      begin
        i:=i+1;
      end;
    end;
    if(not(Ketemu))then
    begin
      write('ERROR : UFile -> Ada entri inventori bahan olahan (');
      write(Nama);
      writeln(')  yang tidak punya entri di file bahan olahan');
      LoadSukses:=false;
    end;

    cariBahanOlahan:=i;

  end;



  function parse(NamaFile:string):Tabel;

  {KAMUS LOKAL}
  var
    data:Text;
    kolom:integer; {Indeks data}
    baris:integer; {Indeks data}
    temp:string; {Menyimpan data sementara dari file}
    newString:string;
    ch:char; {Menyimpan sementara character dari file saat dibaca}
    line:string;
    i:integer;
    DataTerambil:Tabel;

  {ALGORITMA-PARSE}
  begin
    assign(data, NamaFile);
    reset(data);

    {Mengatur batas maksimal kolom yang dibaca}
    DataTerambil.NKol:=0;
    DataTerambil.NBar:=0;

    baris:=1;

    while (not(eof(data))) do
    begin
      {Proses per baris}
      DataTerambil.NBar:=DataTerambil.Nbar+1;
      readln(data, line);
      i:=0;
      kolom:=1;
      temp:='';
      while(i<=length(line)) do
      begin
        {Proses per karakter}
        ch:=line[i];
        if(ch='|')then
        begin
          {Jika ketemu karakter pemisah masukkan semua string sebelum karakter ke tabel}
          kolom:=kolom+1;
          newString := temp;
          delete(newString,1,1);
          delete(newString,length(newString),1);
          DataTerambil.Isi[baris][kolom-1]:=newString;

          temp:='';
        end else
        begin
          {Jika bukan karakter pemisah, tambahkan karakter ke string sementara}
          temp:=temp+ch;
        end;

        {Di ujung juga lakukan hal yang sama seperti ketemu pemisah}
        if(i=length(line))then
        begin
          kolom:=kolom+1;
          newString:=temp;
          delete(newString,1,1);
          DataTerambil.Isi[baris][kolom-1]:=newString;
        end;

        i:=i+1;
      end;

      {set NKol ke kolom terbanyak di file}
      if(kolom>DataTerambil.NKol)then
      begin
        DataTerambil.NKol := kolom;
      end;

      baris:=baris + 1;

    end;

    close(data);

    parse:=DataTerambil;

  end;



  function getBahanMentah(Input:Tabel):DaftarBahanMentah;

  {Kamus lokal}
  var
    i:integer;
    Hasil:DaftarBahanMentah; {variabel getBahanMentah sementara}
    KodeError:integer; {akan =/= 0 saat ada error}
    IsError:boolean;

  {Algoritma - getBahanMentah}
  begin
    {Untuk setiap data ubah ke format yang dimau}
    for i:=1 to Input.NBar do
    begin
      Hasil.Isi[i].Nama := Input.Isi[i][1];

      Val(Input.Isi[i][2],Hasil.Isi[i].Harga,KodeError);
      IsError:=(KodeError<>0);

      Val(Input.Isi[i][3],Hasil.Isi[i].Kadaluarsa,KodeError);
      IsError:= IsError or (KodeError<>0);

      if(isError)then
      begin
        write('ERROR : UFile -> Error dalam membaca file bahan mentah, baris ');
        writeln(i);
        LoadSukses:=false;
      end;

    end;

    Hasil.Neff:=Input.Nbar;
    InternalBahanMentah:=Hasil;
    getBahanMentah:=Hasil;

  end;



  function getBahanOlahan(Input:Tabel):DaftarBahanOlahan;

  {Kamus lokal}
  var
    i,j:integer;
    Hasil:DaftarBahanOlahan; {variabel getBahanOlahan sementara}
    JumlahBahanMentah:integer;
    KodeError:integer; {akan =/= 0 saat ada error}
    IsError:boolean;

  {Algoritma - getBahanOlahan}
  begin
    {Untuk setiap data ubah ke format yang dimau}
    for i:=1 to Input.NBar do
    begin
      Hasil.Isi[i].Nama := Input.Isi[i][1];

      Val(Input.Isi[i][2], Hasil.Isi[i].Harga,KodeError);
      IsError:=(KodeError<>0);

      Val(Input.Isi[i][3],JumlahBahanMentah,KodeError);
      IsError:= IsError or (KodeError<>0);

      if(IsError)then
      begin
        write('ERROR : UFile -> Error dalam membaca file bahan olahan, baris ');
        writeln(i);
        LoadSukses:=false;
      end;

      Hasil.Isi[i].JumlahBahan:=JumlahBahanMentah;

      for j:=1 to JumlahBahanMentah do
      begin
        Hasil.Isi[i].Bahan[j] := Input.isi[i][j+3];
      end;
    end;

    Hasil.Neff:=Input.NBar;
    InternalBahanOlahan:=Hasil;
    getBahanOlahan:=Hasil;

  end;



  function getInventoriBahanMentah(Input:Tabel):InventoriBahanMentah;

  {Kamus lokal}
  var
    i:integer;
    Hasil:InventoriBahanMentah; {variabel InventoriBahanMentah sementara}
    KodeError:integer; {akan =/= 0 saat ada error}
    IsError:boolean;
    IndeksBahan:integer;

  {Algoritma - getInventoriBahanMentah}
  begin
    {Cek apakah sudah ada daftar bahan mentah agar dapat dicocokkan dengan inventori}
    if(InternalBahanMentah.Isi[1].Nama = '')then
    begin
      writeln('ERROR : UFile -> File inventori bahan mentah dibaca sebelum file bahan mentah');
      LoadSukses:=false;
    end else
    begin
      {Untuk setiap data ubah ke format yang dimau}
      Hasil.Total := 0;
      for i:=1 to Input.NBar do
      begin
        IndeksBahan := cariBahanMentah(Input.Isi[i][1]);
        Hasil.Isi[i].Nama := InternalBahanMentah.Isi[IndeksBahan].Nama;
        Hasil.Isi[i].Harga := InternalBahanMentah.Isi[IndeksBahan].Harga;
        Hasil.Isi[i].Kadaluarsa := InternalBahanMentah.Isi[IndeksBahan].Kadaluarsa;

        Hasil.TanggalBeli[i] := getTanggal(Input.Isi[i][2]);

        Val(Input.Isi[i][3],Hasil.Jumlah[i],KodeError);

        Hasil.Total := Hasil.Total + Hasil.Jumlah[i];

        IsError:=(KodeError<>0);

        if(isError)then
        begin
          write('ERROR : UFile -> Error dalam membaca file inventori bahan mentah, baris ');
          writeln(i);
          LoadSukses:=false;
        end;
      end;
    end;

    Hasil.Neff:=Input.Nbar;
    getInventoriBahanMentah:=Hasil;

  end;



  function getInventoriBahanOlahan(Input:Tabel):InventoriBahanOlahan;

  {Kamus lokal}
  var
    i:integer;
    Hasil:InventoriBahanOlahan; {variabel InventoriBahanOlahan sementara}
    KodeError:integer; {akan =/= 0 saat ada error}
    IsError:boolean;
    IndeksBahan:integer;

  {Algoritma - getInventoriBahanOlahan}
  begin
    {Cek apakah sudah ada daftar bahan olahan untuk dicocokkan dengan inventori}
    if(InternalBahanOlahan.Isi[1].Nama = '')then
    begin
      writeln('ERROR : UFile -> File inventori bahan olahan dibaca sebelum file bahan mentah');
      LoadSukses:=false;
    end else
    begin
      {Untuk setiap data ubah ke format yang dimau}
      Hasil.Total := 0;
      for i:=1 to Input.NBar do
      begin
        IndeksBahan := cariBahanOlahan(Input.Isi[i][1]);
        Hasil.Isi[i].Nama := InternalBahanOlahan.Isi[IndeksBahan].Nama;
        Hasil.Isi[i].Harga := InternalBahanOlahan.Isi[IndeksBahan].Harga;
        Hasil.Isi[i].JumlahBahan := InternalBahanOlahan.Isi[IndeksBahan].JumlahBahan;

        Hasil.Isi[i].Bahan := InternalBahanOlahan.Isi[IndeksBahan].Bahan;

        Hasil.TanggalBuat[i] := getTanggal(Input.Isi[i][2]);

        Val(Input.Isi[i][3],Hasil.Jumlah[i],KodeError);

        Hasil.Total := Hasil.Total + Hasil.Jumlah[i];

        IsError:=(KodeError<>0);

        if(isError)then
        begin
          write('ERROR : UFile -> Error dalam membaca file inventori bahan olahan, baris ');
          writeln(i);
          LoadSukses:=false;
        end;
      end;
    end;

    Hasil.Neff:=Input.Nbar;
    getInventoriBahanOlahan:=Hasil;

  end;



  function getResep(Input:Tabel):DaftarResep;

  {Kamus Lokal}
  var
    i,j:integer;
    Hasil:DaftarResep; {variabel DaftarResep sementara}
    JumlahBahan:integer;
    KodeError:integer; {akan =/= 0 saat ada error}
    IsError:boolean;

  {Algoritma - getResep}
  begin
    {Untuk setiap data ubah ke format yang dimau}
    for i:=1 to Input.NBar do
    begin
      Hasil.Isi[i].Nama := Input.Isi[i][1];

      Val(Input.Isi[i][2],Hasil.Isi[i].Harga,KodeError);
      IsError:=(KodeError<>0);

      Val(Input.Isi[i][3],JumlahBahan,KodeError);
      IsError:= IsError or (KodeError<>0);

      Hasil.Isi[i].JumlahBahan:=JumlahBahan;

      for j:=1 to JumlahBahan do
      begin
        Hasil.Isi[i].Bahan[j] := Input.isi[i][j+3];
      end;

      if(isError)then
      begin
        write('ERROR : UFile -> Error dalam membaca file resep, baris ');
        writeln(i);
        LoadSukses:=false;
      end;

    end;

    Hasil.Neff:=Input.Nbar;
    getResep:=Hasil;

  end;



  function getSimulasi(Input:Tabel):DaftarSimulasi;

  {Kamus Lokal}
  var
    i:integer;
    Hasil:DaftarSimulasi;
    KodeError:integer;
    IsError:boolean;

  {Algoritma - getSimulasi}
  begin
    {Untuk setiap data ubah ke format yang dimau}
    for i:=1 to Input.NBar do
    begin
      Val(Input.Isi[i][1], Hasil.Isi[i].Nomor,KodeError);
      IsError:=(KodeError<>0);

      Hasil.Isi[i].Tanggal := getTanggal(Input.Isi[i][2]);

      Val(Input.Isi[i][3], Hasil.Isi[i].JumlahHidup,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][4], Hasil.Isi[i].Energi,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][5], Hasil.Isi[i].Kapasitas,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][6], Hasil.Isi[i].BeliMentah,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][7], Hasil.Isi[i].BuatOlahan,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][8], Hasil.Isi[i].JualOlahan,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][9], Hasil.Isi[i].JualResep,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][10], Hasil.Isi[i].Pemasukan,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][11], Hasil.Isi[i].Pengeluaran,KodeError);
      IsError:= IsError or (KodeError<>0);

      Val(Input.Isi[i][12], Hasil.Isi[i].TotalUang,KodeError);
      IsError:= IsError or (KodeError<>0);

      if(IsError)then
      begin
        write('ERROR : UFile -> Error dalam membaca file simulasi, baris ');
        writeln(i);
        LoadSukses:=false;
      end;

    end;

    Hasil.Neff:=Input.NBar;
    getSimulasi:=Hasil;

  end;

procedure tulisBalik(InputBahanMentah:DaftarBahanMentah; InputBahanOlahan:DaftarBahanOlahan; InputResep:DaftarResep; InputSimulasi:DaftarSimulasi);
{Kamus}
var
i,j: integer;
fout: text;
{Algoritma}
begin
  assign(fout, 'bahan_mentah.txt');
  rewrite(fout);

  for i:=1 to InputBahanMentah.Neff do
  begin
    write(fout,InputBahanMentah.Isi[i].Nama);
    write(fout,' | ');
    write(fout,InputBahanMentah.Isi[i].Harga);
    write(fout,' | ');
    write(fout,InputBahanMentah.Isi[i].Kadaluarsa);
    writeln(fout);
  end;

  close(fout);

  assign(fout, 'bahan_olahan.txt');
  rewrite(fout);

  for i:=1 to InputBahanOlahan.Neff do
  begin
    write(fout,InputBahanOlahan.Isi[i].Nama);
    write(fout,' | ');
    write(fout,InputBahanOlahan.Isi[i].Harga);
    write(fout,' | ');
    write(fout,InputBahanOlahan.Isi[i].JumlahBahan);
    for j:= 1 to (InputBahanOlahan.Isi[i].JumlahBahan) do
      begin
        write(fout,' | ');
        write(fout,InputBahanOlahan.Isi[i].Bahan[j]);
      end;
    writeln(fout);
  end;

  close(fout);

  assign(fout, 'resep.txt');
  rewrite(fout);

  for i:=1 to InputResep.Neff do
  begin
    write(fout,InputResep.Isi[i].Nama);
    write(fout,' | ');
    write(fout,InputResep.Isi[i].Harga);
    write(fout,' | ');
    write(fout,InputResep.Isi[i].JumlahBahan);

    for j:=1 to InputResep.Isi[i].JumlahBahan do
    begin
      write(fout,' | ');
      write(fout,InputResep.Isi[i].Bahan[j]);
    end;
    writeln(fout);
  end;

  close(fout);

  assign(fout, 'simulasi.txt');
  rewrite(fout);

  for i:=1 to InputSimulasi.Neff do
  begin
    write(fout,InputSimulasi.Isi[i].Nomor);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].Tanggal.Hari);
    write(fout,'/');
    write(fout,InputSimulasi.Isi[i].Tanggal.Bulan);
    write(fout,'/');
    write(fout,InputSimulasi.Isi[i].Tanggal.Tahun);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].JumlahHidup);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].Energi);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].Kapasitas);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].BeliMentah);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].BuatOlahan);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].JualOlahan);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].JualResep);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].Pemasukan);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].Pengeluaran);
    write(fout,' | ');
    write(fout,InputSimulasi.Isi[i].TotalUang);
    writeln(fout);
  end;

  close(fout);

end;

procedure tulisInventori(InputInventoriBahanMentah:InventoriBahanMentah; InputInventoriBahanOlahan:InventoriBahanOlahan;Nomor:integer);
{Kamus}
var
i: integer;
fout: text;
NamaTxt:string;

{ALGORITMA - tulisInventori}
begin
  Str(nomor,NamaTxt);
  NamaTxt := 'inventori_bahan_mentah_'+NamaTxt+'.txt';

  assign(fout, NamaTxt);
  rewrite(fout);

  for i:=1 to InputInventoriBahanMentah.Neff do
  begin
    if(InputInventoriBahanMentah.Jumlah[i]<>0)then
    begin
      write(fout,InputInventoriBahanMentah.Isi[i].Nama);
      write(fout,' | ');
      write(fout,InputInventoriBahanMentah.TanggalBeli[i].Hari);
      write(fout,'/');
      write(fout,InputInventoriBahanMentah.TanggalBeli[i].Bulan);
      write(fout,'/');
      write(fout,InputInventoriBahanMentah.TanggalBeli[i].Tahun);
      write(fout,' | ');
      write(fout,InputInventoriBahanMentah.Jumlah[i]);
      writeln(fout);
    end;
  end;

  close(fout);

  Str(nomor,NamaTxt);
  NamaTxt := 'inventori_bahan_olahan_'+NamaTxt+'.txt';

  assign(fout, NamaTxt);
  rewrite(fout);

  for i:=1 to InputInventoriBahanOlahan.Neff do
  begin
    if(InputInventoriBahanOlahan.Jumlah[i]<>0)then
    begin
      write(fout,InputInventoriBahanOlahan.Isi[i].Nama);
      write(fout,' | ');
      write(fout,InputInventoriBahanOlahan.TanggalBuat[i].Hari);
      write(fout,'/');
      write(fout,InputInventoriBahanOlahan.TanggalBuat[i].Bulan);
      write(fout,'/');
      write(fout,InputInventoriBahanOlahan.TanggalBuat[i].Tahun);
      write(fout,' | ');
      write(fout,InputInventoriBahanOlahan.Jumlah[i]);
      writeln(fout);
    end;
  end;

  close(fout);
end;

end.
