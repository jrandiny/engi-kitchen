program Main;

uses UFile, UTipe, UTanggal, USimulasi, UInventori, UResep, UUI, sysutils;

{Kamus}
var
  MasukanUser:string;
  InputTerproses:UserInput;
  OpsiAngka:integer;
  KodeError:integer;
  isInputValid, isSimulasiAktif: boolean;
  i: integer;
  ResepBaru: Resep;
  HargaResep: longint;
  StringInput: string;
  Error : boolean;
  DeltaUang:longint;
  NamaTxt:string;
  PerintahMungkin:DaftarPerintah;

const
  HARGAUPGRADE = 1000;

  procedure loadInventori(nomor:string);
  {I.S. : Ada file inventori dan diberi nomor inventori}
  {F.S. : File inventori terload}

  begin
    LoadSukses:=true;
    NamaTxt := 'inventori_bahan_mentah_'+nomor+'.txt';
    InventoriM := getInventoriBahanMentah(parse(NamaTxt));
    InventoriM.Sorted:=false;
    NamaTxt := 'inventori_bahan_olahan_'+nomor+'.txt';
    InventoriO := getInventoriBahanOlahan(parse(NamaTxt));
    InventoriO.sorted:=false;
    sortArray();
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

  procedure hentikanSimulasi();
  {I.S. Simulasi berjalan}
  {F.S. Simulasi berhenti}
	begin
		lihatStatistik();
		isInputValid := true;
		isSimulasiAktif := false;
    tulisInventori(InventoriM,InventoriO,SimulasiAktif.Nomor);
    SemuaSimulasi.Isi[SimulasiAktif.Nomor]:=SimulasiAktif;
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

procedure loadData();
{I.S. : variabel di unit-unit kosong}
{F.S. : Variabel di unit-unit terisi}
begin
  LoadSukses:=true;
  DaftarBahanM := getBahanMentah(parse('bahan_mentah.txt'));
  DaftarBahanO := getBahanOlahan(parse('bahan_olahan.txt'));
  ResepResep := getResep(parse('resep.txt'));
  ResepResep.Sorted:=false;
  sortResep();
  SemuaSimulasi:= getSimulasi(parse('simulasi.txt'));
end;

procedure showHelp();
{I.S. : Tampilan layar kosong}
{F.S. : Dicetak help}
begin
  writelnText('Perintah tersedia');
  writelnText('load           Memuat data dari file');
  writelnText('exit           Keluar');
  writelnText('start          Memulai simulasi');
  writelnText('stop           Mengentikan simulasi');
  writelnText('lihatinventori Menampilkan inventori');
  writelnText('lihatresep     Menampilkan daftar resep');
  writelnText('cariresep      Mencari resep');
  writelnText('tambahresep    Menambah resep ke daftar');
  writelnText('');
  writelnText('Perintah khusus dalam simulasi');
  writelnText('belibahan      Membeli bahan mentah');
  writelnText('olahbahan      Mengolah bahan mentah jadi olahan');
  writelnText('jualolahan     Menjual bahan hasil olahan');
  writelnText('jualresep      Membuat dan menjual makanan sesuai resep');
  writelnText('tidur          Memajukan hari dan mengembalikan energi serta menghapus item kadaluarsa');
  writelnText('makan          Menambah 3 energi');
  writelnText('istirahat      Menambah 1 energi');
  writelnText('lihatstatistik Melihat statistik');

end;



{Algoritma}
begin
  isSimulasiAktif:=false;
  LoadSukses:=false;

  while(true)do
  begin
    prompt(MasukanUser,isSimulasiAktif);
    InputTerproses := bacaInput(MasukanUser);

    if(not(isSimulasiAktif))then
    begin
      isInputValid := true;

      case LowerCase(InputTerproses.Perintah) of
        'load' : begin
          loadData();
          if(LoadSukses)then
          begin
            writelnText('Load data berhasil');
          end;
        end;
        'exit' : begin
          if(LoadSukses)then
          begin
            tulisBalik(DaftarBahanM,DaftarBahanO,ResepResep,SemuaSimulasi);
          end;
          Halt();
        end;
        'start' : begin
          if(LoadSukses)then
          begin
            if (InputTerproses.Neff = 0) then
            begin
        			write('Nomor simulasi: ');
        			readln(InputTerproses.Opsi[1]);
            end;
            Val(InputTerproses.Opsi[1],OpsiAngka,KodeError);
            if(KodeError<>0)then
            begin
              writeError('Main','Input opsi bukan angka');
            end else
            begin
              loadInventori(InputTerproses.Opsi[1]);
              if(LoadSukses)then
              begin
                startSimulasi(OpsiAngka,Error);
                if(not(Error)) then
                begin
                  isSimulasiAktif:=true;
                end;
              end else
              begin
                writeError('Main','Loading inventori gagal');
              end;
            end;
          end else
          begin
            writeError('Main','Loading belum sukses');
          end;

        end;
        else
        begin
          isInputValid := false;
        end;
      end;
    end else
    begin
      isInputValid := true;
      case LowerCase(InputTerproses.Perintah) of
        'stop' : begin
          hentikanSimulasi();
        end;
        'belibahan' : begin
    		  if (InputTerproses.Neff < 1 ) then
    		  begin
      			write('Nama bahan: ');
      			readln(InputTerproses.Opsi[1]);
    		  end;
          formatUserInput(InputTerproses.Opsi[1]);

          if (InputTerproses.Neff < 2) then
          begin
            write('Jumlah bahan: ');
      			readln(InputTerproses.Opsi[2]);
          end;
          Val(InputTerproses.Opsi[2],OpsiAngka,KodeError);

          if(KodeError<>0)then
          begin
            writeError('Main','Jumlah bahan harus berupa angka');
          end else
          begin
            pakeEnergi(Error);
            if(not(Error)) then
            begin
              DeltaUang := beliBahan(InputTerproses.Opsi[1], OpsiAngka);
              if(DeltaUang<>-1)then
              begin
                pakaiUang(DeltaUang+1, Error);
                ubahStatistik(1, OpsiAngka);
                writelnText('Berhasil membeli ' + InputTerproses.Opsi[1]);
              end;
            end;
          end;
        end;
        'olahbahan' : begin
          if (InputTerproses.Neff = 0) then
          begin
            write('Nama bahan olahan: ');
            readln(InputTerproses.Opsi[1]);
          end;
          formatUserInput(InputTerproses.Opsi[1]);
          pakeEnergi(Error);
          if(not(Error)) then
          begin
            olahBahan(InputTerproses.Opsi[1], Error);
            if not(Error) then
            begin
              ubahStatistik(2,1);
              writelnText('Berhasil membuat ' + InputTerproses.Opsi[1]);
            end;
          end;
        end;
        'jualolahan' : begin
          if (InputTerproses.Neff < 1) then
          begin
            write('Nama bahan olahan: ');
    			  readln(InputTerproses.Opsi[1]);
          end;
          formatUserInput(InputTerproses.Opsi[1]);
		      if (InputTerproses.Neff < 2) then
    		  begin
    			  write('Jumlah bahan olahan untuk dijual: ');
    			  readln(InputTerproses.Opsi[2]);
    		  end;
    		  Val(InputTerproses.Opsi[2],OpsiAngka,KodeError);

    		  if(KodeError<>0)then
    		  begin
    		    writeError('Main','Jumlah bahan untuk dijual harus berupa angka');
    		  end else
    		  begin
            pakeEnergi(Error);
            if(not(Error)) then
            begin
              DeltaUang:=jualOlahan(InputTerproses.Opsi[1], OpsiAngka);
              if (DeltaUang<>-1) then
              begin
                tambahUang(DeltaUang+1);
                ubahStatistik(3,OpsiAngka);
                writelnText('Berhasil menjual ' +  InputTerproses.Opsi[1]);
              end;
            end;
          end;
        end;
        'jualresep' : begin
          if (InputTerproses.Neff = 0) then
          begin
      			write('Nama resep: ');
      			readln(InputTerproses.Opsi[1]);
    		  end;
          formatUserInput(InputTerproses.Opsi[1]);

          pakeEnergi(Error);
          if(not(Error)) then
          begin
            DeltaUang:=jualResep(InputTerproses.Opsi[1]);
            if (DeltaUang <> -1) then
            begin
              tambahUang(DeltaUang+1);
              ubahStatistik(4, 1);
              writelnText('Berhasil menjual ' + InputTerproses.Opsi[1]);
            end;
          end;
        end;
        'makan' : begin
          makan();
        end;
        'istirahat' : begin
          istirahat();
        end;
        'tidur' : begin
          tidur(Error);
          if(not(Error))then
          begin
            writelnText('Berhasil tidur');
            hapusKadaluarsa();
            if(SimulasiAktif.JumlahHidup=10)then
            begin
              writelnText('Simulasi selesai (10 hari)');
              hentikanSimulasi();
            end
          end;

        end;
        'lihatstatistik' : begin
          lihatStatistik();
        end;
        'statistik' : begin
          lihatStatistik();
        end;
        else
        begin
          isInputValid := false;
        end;
      end;
    end;

    isInputValid := not(isInputValid);

    case LowerCase(InputTerproses.Perintah) of
      'upgradeinventori':begin
        upgradeInventori(Error);
        if (not(Error)) then
        begin
          pakaiUang(HARGAUPGRADE, Error);
          writelnText('Berhasil menambah kapasitas inventori menjadi ' + IntToStr(SimulasiAktif.Kapasitas));
        end;
      end;

      'lihatresep':begin
        sortResep();
        lihatresep();
      end;

      'help':begin
        writelnText('Engi''s Kitchen');
        showHelp();
      end;

      'lihatinventori' : begin
        if(not(isSimulasiAktif))then
        begin
          if (InputTerproses.Neff = 0) then
          begin
            write('Nomor Inventori: ');
            readln(InputTerproses.Opsi[1]);
          end;
          Val(InputTerproses.Opsi[1],OpsiAngka,KodeError);
    		  if(KodeError<>0)then
    		  begin
    		    writeError('Main','Nomor inventori harus berupa angka');
    		  end else
          begin
            loadInventori(InputTerproses.Opsi[1]);
            if(LoadSukses)then
            begin
              sortArray();
              lihatInventori();
            end else
            begin
              writeError('Main','Load inventori gagal');
            end;

          end;
        end else
        begin
          sortArray();
          lihatInventori();
        end;
      end;

      'cariresep' : begin
        if (InputTerproses.Neff = 0) then
        begin
          write('Nama resep: ');
          readln(InputTerproses.Opsi[1]);
        end;
        formatUserInput(InputTerproses.Opsi[1]);
        cariResep(InputTerproses.Opsi[1]);
      end;

      'tambahresep' : begin
        if(InputTerproses.Neff = 0) then
        begin
      		write('Nama resep: ');
      		readln(InputTerproses.Opsi[1]);
    	  end;
        formatUserInput(InputTerproses.Opsi[1]);

        ResepBaru.Nama := InputTerproses.Opsi[1];
        write('Harga: ');
        readln(StringInput);
        Val(StringInput,HargaResep,KodeError);
        if(KodeError<>0) then
        begin
  		    writeError('Main','Harga harus berupa angka');
  		  end else
  		  begin
  		    ResepBaru.Harga := HargaResep;
    			write('Jumlah bahan: ');
    			readln(StringInput);
    			Val(StringInput,OpsiAngka,KodeError);
    			if(KodeError<>0) then
    			begin
    			  writeError('Main','Jumlah bahan harus berupa angka');
  		    end else
  		    begin
    			  ResepBaru.JumlahBahan := OpsiAngka;
    			  writelnText('Daftar bahan: ');
            for i := 1 to ResepBaru.JumlahBahan do
            begin
              write('   ', i, '. ');
              readln(ResepBaru.Bahan[i]);
              formatUserInput(ResepBaru.Bahan[i]);
    			  end;
			      tambahResep(ResepBaru, Error);
            if (not(Error)) then
            begin
              writelnText('Berhasil menambahkan resep ' + ResepBaru.Nama);
            end;
			    end;
  	    end;
      end;
      else
      begin
        isInputValid := not(isInputValid);
      end;
    end;

    if(not(isInputValid))then
    begin
      writeError('Main', 'Perintah tidak valid');
      if(isSimulasiAktif)then
      begin
        {Isi daftar}
        PerintahMungkin.Isi[1]:='stop';
        PerintahMungkin.Isi[2]:='lihatinventori';
        PerintahMungkin.Isi[3]:='lihatresep';
        PerintahMungkin.Isi[4]:='cariresep';
        PerintahMungkin.Isi[5]:='tambahresep';
        PerintahMungkin.Isi[6]:='belibahan';
        PerintahMungkin.Isi[7]:='olahbahan';
        PerintahMungkin.Isi[8]:='jualolahan';
        PerintahMungkin.Isi[9]:='jualresep';
        PerintahMungkin.Isi[10]:='tidur';
        PerintahMungkin.Isi[11]:='makan';
        PerintahMungkin.Isi[12]:='istirahat';
        PerintahMungkin.Isi[13]:='lihatstatistik';
        PerintahMungkin.Isi[14]:='upgradeinventori';
        PerintahMungkin.Neff := 13;
      end else
      begin
        {Isi daftar}
        PerintahMungkin.Isi[1]:='load';
        PerintahMungkin.Isi[2]:='exit';
        PerintahMungkin.Isi[3]:='start';
        PerintahMungkin.Isi[5]:='lihatinventori';
        PerintahMungkin.Isi[6]:='lihatresep';
        PerintahMungkin.Isi[7]:='cariresep';
        PerintahMungkin.Isi[8]:='tambahresep';
        PerintahMungkin.Neff := 8;
      end;
      commandPredictor(InputTerproses.Perintah,PerintahMungkin);
    end;


  end;
end.
