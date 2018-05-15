unit UInventori;

interface

  uses UTipe,UTanggal,USimulasi,UUI,sysutils;

  var
    DaftarBahanM      : DaftarBahanMentah;
    DaftarBahanO      : DaftarBahanOlahan;
    InventoriM        : InventoriBahanMentah;
    InventoriO        : InventoriBahanOlahan;

  function isBahanAda(input : string) : boolean;
  {menerima input nama bahan dan cek apakah bahan ada}

  function beliBahan(input : string; JumlahBeli : integer):longint;
  {Menerima nama Bahan dan Jumlah yang mau dibeli. Mengembalikan total harga
  yang dikeluarkan, mengembalikan -1 jika error}

  function jualOlahan(input : string; JumlahJual:integer):longint;
  {Menerima namaOlahan yang ingin dijual dan jumlah yang ingin dijual. Mengembalikan
  nilai uang yang didapat, mengembalikan -1 jika error}

  procedure kuranginBahan(input : string; var Error : boolean);
  {I.S : membaca namaBahan }
  {F.S : Mengurangi bahan sebanyak 1 , jika error variabel Error akan bernilai true}

  procedure hapusKadaluarsa();
  {I.S : terdefinisi tanggal simulasi dan inventori}
  {F.S : Menghapus bahan-bahan yang sudah kadaluarsa, bahan mentah kadaluarsa
  berbeda-beda tergantung jenis bahan, untuk olahan kadaluarsa 3 hari dari setelah dibuat}

  procedure lihatInventori();
  {I.S : InventoriM dan InventoriO terdefinisi}
  {F.S : Menampilkan daftar inventori keseluruhan}

  procedure olahBahan(input : string; var Error : boolean);
  {I.S : Menerima input Nama bahan olahan yang ingin diolah}
  {F.S : Mengolah bahan-bahan mentah menjadi 1 bahan olahan, jika error variabel
  Error akan bernilai true}

  procedure sortArray();
  {I.S  : InventoriM dan InventoriO terdefinisi}
  {F.S : Menyortir keseluruhan inventoriM dan inventoriO}

  function searchIndex(input : string; kode : string): integer;
  {Menerima nama bahan yang dicari beserta kode tempat mencari, lalu mengembalikan
  posisi indeks di daftar yang sesuai dan punya kadaluarsa paling cepat jika
  inventori, mengoutput -1 jika tidak ada}

implementation



  procedure hapusKadaluarsa();

  {Kamus Lokal}
  var
    i : integer;
    count : integer;

  {Algoritma hapusKadaluarsa}
  begin
    {cek inventori bahan mentah -> expired sesuai jenis bahan}
    count:=0;
    for i := 1 to InventoriM.Neff do
    begin
      {Jika dengan alasan tertentu tanggal beli bisa lebih dari tanggal simulasi, abaikan}
      if (isTanggalDuluan(InventoriM.TanggalBeli[i],SimulasiAktif.Tanggal))then
      begin
        {expired sesuai jenis bahan}
        if (selisihTanggal(InventoriM.TanggalBeli[i],SimulasiAktif.Tanggal) > InventoriM.Isi[i].Kadaluarsa) then
        begin
          count:= count + InventoriM.Jumlah[i];
          InventoriM.Jumlah[i] := 0;
          inventoriM.Total:= inventoriM.Total - count;
        end;
      end;
    end;

    {cek inventori bahan olahan -> expired 3 hari}
    count:=0;
    for i := 1 to InventoriO.Neff do
    begin
      {Jika dengan alasan tertentu tanggal buat bisa lebih dari tanggal simulasi, abaikan}
      if(isTanggalDuluan(InventoriO.TanggalBuat[i],SimulasiAktif.Tanggal))then
      begin
        {expired 3 hari}
        if (selisihTanggal(InventoriO.TanggalBuat[i],SimulasiAktif.Tanggal)>3) then
        begin
          count := count + InventoriO.Jumlah[i];
          InventoriO.Jumlah[i] := 0;
          inventoriO.Total := inventoriO.Total - count;
        end;
      end;
    end;
  end;

  procedure lihatInventori();
  {KAMUS LOKAL}
  var
    i:integer;

  {ALGORITMA - lihatInventori}
  begin
    writeln('-------DAFTAR INVENTORI BAHAN MENTAH--------');
    writeln('NAMA BAHAN          JUMLAH      TANGGAL BELI');
    for i := 1 to InventoriM.Neff do
    begin
      write(Format('%-20s',[InventoriM.Isi[i].Nama]));
      write(Format('%-12d',[InventoriM.Jumlah[i]]));
      write(InventoriM.TanggalBeli[i].Hari);
      write('/');
      write(InventoriM.TanggalBeli[i].Bulan);
      write('/');
      write(InventoriM.TanggalBeli[i].Tahun);
      writeln();
    end;
    writeln('Total : ', InventoriM.Total);
    writeln('-------DAFTAR INVENTORI BAHAN OLAHAN--------');
    writeln('NAMA BAHAN          JUMLAH      TANGGAL BUAT');
    for i:=1 to InventoriO.Neff do
    begin
      write(Format('%-20s',[InventoriO.Isi[i].Nama]));
      write(Format('%-12d',[InventoriO.Jumlah[i]]));
      write(InventoriO.TanggalBuat[i].Hari);
      write('/');
      write(InventoriO.TanggalBuat[i].Bulan);
      write('/');
      write(InventoriO.TanggalBuat[i].Tahun);
      writeln();
    end;
    writeln('Total : ', InventoriO.Total);
  end;

  function isBahanAda(input : string): boolean;
  {KAMUS LOKAL}
  var
    Ketemu : boolean;
    id:integer;

  {Algoritma - isBahanAda}
  begin
    Ketemu := false;
    id:=searchIndex(input, 'IM');
    {jika id = -1 artinya tidak ketemu}
    if(id=-1)then
    begin
      id:=searchIndex(input, 'IO');
      if(id<>-1)then
      begin
        Ketemu:=true;
      end;
    end else
    begin
      Ketemu := true;
    end;
    isBahanAda := Ketemu;
  end;

  function beliBahan(input : string; JumlahBeli : integer):longint;

  {KAMUS LOKAL}
  var
      j             :   integer;    {increment}
      IndeksBahan     :   integer;    {index bahan}
      BahanDibeli     :   BahanMentah;
      AdaSama         :   boolean;
      IndeksSama      :   integer;
      Uang            : longint;

  {Algoritma BeliBahan}
  begin
    Uang:=-1;
    {cek apa masih ada kapasitas}
    if ((InventoriM.Total + InventoriO.Total + JumlahBeli) > SimulasiAktif.Kapasitas) then
    begin
      writeError('UInventori','Inventori tidak cukup');
    end else
    begin
      {cek apa bahan ada}
      IndeksBahan := searchIndex(input, 'DM');
      if (IndeksBahan <> -1) then
      begin
        {cek apa ada uang}
        if ((DaftarBahanM.Isi[IndeksBahan].Harga*JumlahBeli) > SimulasiAktif.TotalUang) then
        begin
          writeError('UInventori','Uang tidak cukup');
        end else
        begin
          Uang:=DaftarBahanM.Isi[IndeksBahan].Harga*JumlahBeli;
          AdaSama := false;
          for j := 1 to InventoriM.Neff do
          begin
            {cek apa sudah ada entri}
            if (InventoriM.Isi[j].Nama = input) then
            begin
              {Kalau ada entri yang tanggalnya sama, catat}
              if (isTanggalSama(InventoriM.TanggalBeli[j],SimulasiAktif.Tanggal)) then
              begin
                AdaSama := true;
                IndeksSama := j;
              end;
            end;
          end;
          BahanDibeli := DaftarBahanM.Isi[IndeksBahan];
          {menambahkan entri}
          if (not(AdaSama)) then
          begin
            InventoriM.Isi[InventoriM.Neff+1] := BahanDibeli;
            InventoriM.Jumlah[InventoriM.Neff+1] := JumlahBeli;
            InventoriM.TanggalBeli[InventoriM.Neff+1] := SimulasiAktif.Tanggal;
            InventoriM.Neff := InventoriM.Neff + 1;
            InventoriM.Total := InventoriM.Total + JumlahBeli;

            InventoriM.Sorted:=false;

          end else
          begin
            InventoriM.Jumlah[IndeksSama] := InventoriM.Jumlah[IndeksSama] + JumlahBeli;
            InventoriM.Total := InventoriM.Total + JumlahBeli;
          end;
        end;
      end else
      begin
        writeError('UInventori','Bahan yang ingin dibeli (' + input + ') tidak terdaftar');
      end;
    end;

    beliBahan:=uang;

  end;



  function jualOlahan(input : string; JumlahJual:integer) : longint;

  {KAMUS LOKAL}
  var
    UangDapat : longint;
    IndeksBahan : integer;

  {Algoritma jualOlahan}
  begin
    UangDapat := -1;
    IndeksBahan := searchIndex(input, 'IO');

    {cek apa ada yang mau dijual}
    if (IndeksBahan <> -1) then
    begin
      if (InventoriO.Jumlah[IndeksBahan] < JumlahJual) then
      begin
        writeError('UInventori','Bahan olahan yang ingin dijual (' + input + ') tidak cukup');
      end else
      begin
        {Mengurangi nilai jumlah bahan olahan di inventori sebesar kuantitas yang dijual}
        InventoriO.Jumlah[IndeksBahan] := InventoriO.Jumlah[IndeksBahan] - JumlahJual;
        {Menambah UangDapat}
        UangDapat := (JumlahJual*InventoriO.Isi[IndeksBahan].Harga);
        InventoriO.Total := InventoriO.Total - JumlahJual;
      end;
    end else
    begin
      writeError('UInventori','Bahan olahan yang ingin dijual (' + input + ') tidak ada');
    end;
    jualOlahan := UangDapat
  end;



  procedure olahBahan(input : string; var Error : boolean);

  {KAMUS LOKAL}
  var
    j : integer;
    IndeksBahan : integer;
    BisaBuat : boolean;
    AdaSama : boolean;
    IndeksSama : integer;
    BahanDibuat : BahanOlahan;
    isError : boolean;

  {Algoritma olahBahan}
  begin
    Error := false;
    {cari bahan olahan yg mau dibuat untuk tahu bahan-bahannya}
    IndeksBahan := searchIndex(input,'DO');
    if (IndeksBahan <> -1) then
    begin
      BisaBuat := true;
      j := 1;
      {cek tiap item apakah ada bahannya}
      while ((j <= DaftarBahanO.Isi[IndeksBahan].JumlahBahan) and (BisaBuat)) do
      begin
        if (not(isBahanAda(DaftarBahanO.Isi[IndeksBahan].Bahan[j]))) then
        begin
          BisaBuat := false;
          writeError('UInventori','Tidak ada bahan yang dibutuhkan (' + DaftarBahanO.Isi[IndeksBahan].Bahan[j] + ')');
        end;
        j := j+1;
      end;

      if(BisaBuat)then
      begin
        {kurangi bahan mentah yang diperlukan}
        for j := 1 to DaftarBahanO.Isi[IndeksBahan].JumlahBahan do
        begin
          kuranginBahan(DaftarBahanO.Isi[IndeksBahan].Bahan[j],isError);
        end;

        {cek apakah sudah ada entri bahan olahan dengan jenis dan tanggal sama}
        AdaSama := false;
        for j := 1 to InventoriO.Neff do
        begin
          //cek apa sudah ada entri
          if (InventoriO.Isi[j].Nama = input) then
          begin
            if (isTanggalSama(InventoriO.TanggalBuat[j],SimulasiAktif.Tanggal)) then
            begin
              AdaSama := true;
              IndeksSama := j;
            end;
          end;
        end;

        BahanDibuat := DaftarBahanO.Isi[IndeksBahan];

        {tambah entri}
        if (not(AdaSama)) then
        begin
          InventoriO.Isi[InventoriO.Neff+1] := BahanDibuat;
          InventoriO.Jumlah[InventoriO.Neff+1] := 1;
          InventoriO.TanggalBuat[InventoriO.Neff +1] := SimulasiAktif.Tanggal;
          InventoriO.Neff := InventoriO.Neff + 1;

          InventoriO.Sorted := false;
        end else
        begin
          InventoriO.Jumlah[IndeksSama] := InventoriO.Jumlah[IndeksSama] + 1;
        end;

        InventoriO.Total := InventoriO.Total + 1;

      end else
      begin
        writeError('UInventori','Tidak bisa membuat ' + input);
        Error := true;
      end;
    end else
    begin
      writeError('UInventori','Tidak ada bahan olahan dengan nama ' + input);
      Error := true;
    end;
  end;



  procedure kuranginBahan(input : string; var Error : boolean);

  {KAMUS LOKAL}
  var
    IndeksBahan : integer;

  {Algoritma kuranginBahan}
  begin
    Error := false;
    {cari di inventori mentah}
    IndeksBahan := searchIndex(input, 'IM');
    if (IndeksBahan <> -1) then
    begin
      {cek apa sudah habis}
      if (InventoriM.Jumlah[IndeksBahan] <> 0) then
      begin
        {kurangi}
        InventoriM.Jumlah[IndeksBahan] := InventoriM.Jumlah[IndeksBahan] - 1;
        InventoriM.Total := InventoriM.Total - 1;
      end else
      begin
        Error := true;
      end;
    end else
    begin
      {cari di inventori olahan jika di mentah tak ada}
      IndeksBahan := searchIndex(input, 'IO');
      if (IndeksBahan <> -1) then
      begin
        {cek apa sudah habis}
        if (InventoriM.Jumlah[IndeksBahan] <> 0) then
        begin
          {kurangi}
          InventoriO.Jumlah[IndeksBahan] := InventoriO.Jumlah[IndeksBahan] - 1;
          InventoriO.Total := InventoriO.Total - 1;
        end else
        begin
          Error := true;
        end;
      end else
      begin
        Error := true;
      end;
    end;
    if (Error) then
    begin
      writeError('UInventori','Bahan ' + input + ' sudah habis atau tidak ada');
    end;
  end;

  procedure sortArray();

  {Kamus Lokal}
  var
    n1, n2  :   integer;
    i       :   integer;
    tempM   :   BahanMentah;
    tempT   :   Tanggal; {temporary tanggal}
    tempJ   :   integer; {temporary jumlah}
    tempO   :   BahanOlahan;
    newn    :   integer;
    kondisi1:   boolean;
    kondisi2:   boolean;

  {Algoritma - sortArray}
  begin
    if(not(InventoriM.Sorted))then
    begin
      {sorting bubble sort}
      n1:= InventoriM.Neff;
      repeat
        newn:=0;
        for i:= 2 to InventoriM.Neff do
        begin
          {sorting alfabet}
          kondisi1:=InventoriM.Isi[i-1].Nama > InventoriM.Isi[i].Nama;
          kondisi2:=isTanggalDuluan(InventoriM.TanggalBeli[i],InventoriM.TanggalBeli[i-1])and(InventoriM.Isi[i-1].Nama = InventoriM.Isi[i].Nama);

          if (kondisi1 or kondisi2) then
          begin
            tempT:=InventoriM.TanggalBeli[i-1];
            tempJ:=InventoriM.Jumlah[i-1];
            tempM :=InventoriM.Isi[i-1];

            InventoriM.Isi[i-1] := InventoriM.Isi[i];
            InventoriM.TanggalBeli[i-1] := InventoriM.TanggalBeli[i];
            InventoriM.Jumlah[i-1] := InventoriM.Jumlah[i];

            InventoriM.Isi[i] := tempM;
            InventoriM.TanggalBeli[i]:=tempT;
            InventoriM.Jumlah[i]:=tempJ;

            newn := i;
          end;
        end;
        n1 := newn;
      until (n1 = 0); {hingga tersort}
    end;

    if(not(InventoriO.Sorted))then
    begin
      {sorting bubble sort}
      n2:= InventoriO.Neff;

      repeat
        newn:=0;
        for i:=2 to InventoriO.Neff do
        begin
          {sorting alfabet dan tanggal}
          kondisi1:=InventoriO.Isi[i-1].Nama > InventoriO.Isi[i].Nama;
          kondisi2:=isTanggalDuluan(InventoriO.TanggalBuat[i],InventoriO.TanggalBuat[i-1])and(InventoriO.Isi[i-1].Nama = InventoriO.Isi[i].Nama);

          if (kondisi1 or kondisi2) then
          begin
            tempT:=InventoriO.TanggalBuat[i-1];
            tempJ:=InventoriO.Jumlah[i-1];
            tempO:=InventoriO.Isi[i-1];

            InventoriO.Isi[i-1]:= InventoriO.Isi[i];
            InventoriO.TanggalBuat[i-1] := InventoriO.TanggalBuat[i];
            InventoriO.Jumlah[i-1] := InventoriO.Jumlah[i];

            InventoriO.Isi[i]:= tempO;
            InventoriO.TanggalBuat[i]:=tempT;
            InventoriO.Jumlah[i]:=tempJ;

            newn := i;
          end;
        end;
        n2:= newn;
      until (n2 = 0); {hingga tersort}
    end;

    InventoriM.Sorted := true;
    InventoriO.Sorted := true;
  end;

  function searchIndex(input : string; kode : string): integer;

  {KAMUS LOKAL}
  var
    i:integer;
    Indeks:  array[1..NMAX] of integer;
    Neff  :  integer;
    IndeksDuluan:integer;


  {Algoritma - searchIndex}
  begin
    Neff := 0;
    Indeks[1] := -1;
    if (kode = 'IM') then
    begin
      for i := 1 to InventoriM.Neff do
      begin
        {cari bahan yang masih ada stok}
        if ((input = InventoriM.Isi[i].Nama)and(InventoriM.Jumlah[i]<>0)) then
        begin
          Neff:=Neff+1;
          Indeks[Neff] := i;
        end;
      end;

      {Jika >1 cari yang tanggalnya paling duluan}
      if Neff > 1 then
      begin
        IndeksDuluan:=1;
        for i:=1 to Neff do
        begin
          if(isTanggalDuluan(InventoriM.TanggalBeli[Indeks[i]],InventoriM.TanggalBeli[Indeks[IndeksDuluan]]))then
          begin
            IndeksDuluan:=i;
          end;
        end;

        Indeks[1]:=Indeks[IndeksDuluan];
      end;
    end else if (kode = 'IO') then
    begin
      for i := 1 to InventoriO.Neff do
      begin
        {cari bahan yang masih ada stok}
        if ((input = InventoriO.Isi[i].Nama)and (InventoriO.Jumlah[i]<>0)) then
        begin
          Neff:=Neff+1;
          Indeks[Neff] := i;
        end;
      end;

      {Jika >1 cari yang tanggalnya paling duluan}
      if Neff > 1 then
      begin
        IndeksDuluan:=1;
        for i:=1 to Neff do
        begin
          if(isTanggalDuluan(InventoriO.TanggalBuat[Indeks[i]],InventoriO.TanggalBuat[Indeks[IndeksDuluan]]))then
          begin
            IndeksDuluan:=i;
          end;
        end;
        Indeks[1]:=Indeks[IndeksDuluan];
      end;
    end else if (kode = 'DM') then
    begin
      for i := 1 to DaftarBahanM.Neff do
      begin
        if (input = DaftarBahanM.Isi[i].Nama) then
        begin
          Indeks[1] := i;
          break;
        end;
      end;
    end else if (kode = 'DO') then
    begin
      for i := 1 to DaftarBahanO.Neff do
      begin
        if (input = DaftarBahanO.Isi[i].Nama) then
        begin
          Indeks[1] := i;
          break;
        end;
      end;
    end;
    searchIndex := Indeks[1];
  end;

end.
