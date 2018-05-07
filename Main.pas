program Main;

uses UFile, UTipe, UTanggal, USimulasi, UInventori, UResep;

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

const
  HARGAUPGRADE = 1000;

  procedure loadInventori(nomor:string);
  {I.S. : Ada file inventori dan diberi nomor inventori}
  {F.S. : File inventori terload}

  begin
    LoadSukses:=true;
    NamaTxt := 'inventori_bahan_mentah_'+nomor+'.txt';
    InventoriM := getInventoriBahanMentah(parse(NamaTxt));
    NamaTxt := 'inventori_bahan_olahan_'+nomor+'.txt';
    InventoriO := getInventoriBahanOlahan(parse(NamaTxt));
  end;

  procedure promptPredictor(input:string);
  {I.S. : Terdefinisi perintah-perintah yang mungkin}
  {F.S. : Dicetak ke layar command yang paling mirip}

  {KAMUS LOKAL}
  const
    JUMLAH=16;
    MINCOCOK=0.49;
  var
    Daftar: array[1..JUMLAH]of string;
    Kecocokan : real;
    i,j:integer;
    Total:integer;
    Sama:integer;
    MaxCocok:real;
    IndeksCocok:array[1..JUMLAH]of integer;
    Neff:integer;

  begin
    {Isi daftar}
    Daftar[1]:='load';
    Daftar[2]:='exit';
    Daftar[3]:='start';
    Daftar[4]:='stop';
    Daftar[5]:='lihatinventori';
    Daftar[6]:='lihatresep';
    Daftar[7]:='cariresep';
    Daftar[8]:='tambahresep';
    Daftar[9]:='belibahan';
    Daftar[10]:='olahbahan';
    Daftar[11]:='jualolahan';
    Daftar[12]:='jualresep';
    Daftar[13]:='tidur';
    Daftar[14]:='makan';
    Daftar[15]:='istirahat';
    Daftar[16]:='lihatstatistik';

    {search}
    MaxCocok:=MINCOCOK;
    Neff:=1;
    for i:=1 to JUMLAH do
    begin
      sama:=0;
      total:=Length(input);
      for j:=1 to total do
      begin
        if(j<=Length(Daftar[i]))then
        begin
          if(Daftar[i][j]=input[j])then
          begin
            sama:=sama+1;
          end;
        end;
      end;

      Kecocokan:=sama/total;
      if(Kecocokan>MaxCocok)then
      begin
        MaxCocok:=Kecocokan;
        IndeksCocok[Neff]:=i;
      // end else if(Kecocokan=MaxCocok) then
      // begin
      //   Neff:=Neff+1;
      //   IndeksCocok[Neff]:=i;
      end;
    end;

    {Output yang cocok}
    if((MaxCocok-MINCOCOK)>0.0001)then
    begin
      writeln('Mungkin yang dimaksud :');
      for i:=1 to Neff do
      begin
        writeln(Daftar[IndeksCocok[i]]);
      end;
    end;


  end;

  procedure prompt(var Diketik:string);
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
    x: string;
    Hasil:UserInput;
  {Algoritma}
  begin
    x:= '';
    i:=1;
    Indeks:=1;
    Hasil.Perintah := '';
    Hasil.Opsi1 := '';
    Hasil.Opsi2 := '';

    while (i<=length(Input)) do
    begin
      if ((Input[i]=' ') or (i=length(Input))) then
      begin
        if(i=length(Input))then
        begin
          x := x + Input[i];
        end;
        case Indeks of
          1 : begin
            Hasil.Perintah:=x;
          end;
          2 : begin
            Hasil.Opsi1:=x;
          end;
          3 : begin
            Hasil.Opsi2:=x;
          end;
        end;
        Indeks:=Indeks+1;
        x:='';
      end else
      begin
        x:=x + Input[i];
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
  SemuaSimulasi:= getSimulasi(parse('simulasi.txt'));
end;

procedure showHelp();
{I.S. : Tampilan layar kosong}
{F.S. : Dicetak help}
begin
  writeln('Perintah tersedia');
  writeln('load           Memuat data dari file');
  writeln('exit           Keluar');
  writeln('start          Memulai simulasi');
  writeln('stop           Mengentikan simulasi');
  writeln('lihatinventori Menampilkan inventori');
  writeln('lihatresep     Menampilkan daftar resep');
  writeln('cariresep      Mencari resep');
  writeln('tambahresep    Menambah resep ke daftar');
  writeln();
  writeln('Perintah khusus dalam simulasi');
  writeln('belibahan      Membeli bahan mentah');
  writeln('olahbahan      Mengolah bahan mentah jadi olahan');
  writeln('jualolahan     Menjual bahan hasil olahan');
  writeln('jualresep      Membuat dan menjual makanan sesuai resep');
  writeln('tidur          Memajukan hari dan mengembalikan energi serta menghapus item kadaluarsa');
  writeln('makan          Menambah 3 energi');
  writeln('istirahat      Menambah 1 energi');
  writeln('lihatstatistik Melihat statistik');

end;



{Algoritma}
begin
  isSimulasiAktif:=false;
  LoadSukses:=false;

  while(true)do
  begin
    prompt(MasukanUser);
    InputTerproses := bacaInput(MasukanUser);

    if(not(isSimulasiAktif))then
    begin
      isInputValid := true;

      case LowerCase(InputTerproses.Perintah) of
        'load' : begin
          loadData();
          if(LoadSukses)then
          begin
            writeln('Load data berhasil');
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
            if (InputTerproses.Opsi1 = '') then
            begin
        			write('Nomor simulasi: ');
        			readln(InputTerproses.Opsi1);
            end;
            Val(InputTerproses.Opsi1,OpsiAngka,KodeError);
            if(KodeError<>0)then
            begin
              writeln('ERROR : Main -> Input opsi bukan angka');
            end else
            begin
              loadInventori(InputTerproses.Opsi1);
              if(LoadSukses)then
              begin
                startSimulasi(OpsiAngka,Error);
                if(not(Error)) then
                begin
                  isSimulasiAktif:=true;
                end;
              end else
              begin
                writeln('ERROR : Main -> Loading inventori gagal');
              end;
            end;
          end else
          begin
            writeln('ERROR : Main -> Loading belum sukses');
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
    		  if (InputTerproses.Opsi1 = '') then
    		  begin
      			write('Nama bahan: ');
      			readln(InputTerproses.Opsi1);
    		  end;
          formatUserInput(InputTerproses.Opsi1);
    		  if (InputTerproses.Opsi2 = '') then
    		  begin
      			write('Jumlah bahan: ');
      			readln(InputTerproses.Opsi2);
    		  end;
          Val(InputTerproses.Opsi2,OpsiAngka,KodeError);
          if(KodeError<>0)then
          begin
            writeln('ERROR : Main -> Jumlah bahan harus berupa angka');
          end else
          begin
            pakeEnergi(Error);
            if(not(Error)) then
            begin
              DeltaUang := beliBahan(InputTerproses.Opsi1, OpsiAngka);
              if(DeltaUang<>-1)then
              begin
                pakaiUang(DeltaUang+1, Error);
                ubahStatistik(1, OpsiAngka);
                writeln('Berhasil membeli ', InputTerproses.Opsi1);
              end;
            end;
          end;
        end;
        'olahbahan' : begin
          if (InputTerproses.Opsi1 = '') then
          begin
            write('Nama bahan olahan: ');
            readln(InputTerproses.Opsi1);
          end;
          formatUserInput(InputTerproses.Opsi1);
          pakeEnergi(Error);
          if(not(Error)) then
          begin
            olahBahan(InputTerproses.Opsi1, Error);
            if not(Error) then
            begin
              ubahStatistik(2,1);
              writeln('Berhasil membuat ', InputTerproses.Opsi1);
            end;
          end;
        end;
        'jualolahan' : begin
          if (InputTerproses.Opsi1 = '') then
          begin
            write(InputTerproses.Opsi1);
            write('Nama bahan olahan: ');
    			  readln(InputTerproses.Opsi1);
          end;
          formatUserInput(InputTerproses.Opsi1);
		      if (InputTerproses.Opsi2 = '') then
    		  begin
    			  write('Jumlah bahan olahan untuk dijual: ');
    			  readln(InputTerproses.Opsi2);
    		  end;
    		  Val(InputTerproses.Opsi2,OpsiAngka,KodeError);
    		  if(KodeError<>0)then
    		  begin
    		    writeln('ERROR : Main -> Jumlah bahan untuk dijual harus berupa angka.');
    		  end else
    		  begin
            pakeEnergi(Error);
            if(not(Error)) then
            begin
              DeltaUang:=jualOlahan(InputTerproses.Opsi1, OpsiAngka);
              if (DeltaUang<>-1) then
              begin
                tambahUang(DeltaUang+1);
                ubahStatistik(3,OpsiAngka);
                writeln('Berhasil menjual ', InputTerproses.Opsi1);
              end;
            end;
          end;
        end;
        'jualresep' : begin
          if (InputTerproses.Opsi1 = '') then
          begin
      			write('Nama resep: ');
      			readln(InputTerproses.Opsi1);
    		  end;
          formatUserInput(InputTerproses.Opsi1);
          pakeEnergi(Error);
          if(not(Error)) then
          begin
            DeltaUang:=jualResep(InputTerproses.Opsi1);
            if (DeltaUang <> -1) then
            begin
              tambahUang(DeltaUang+1);
              ubahStatistik(4, 1);
              writeln('Berhasil menjual ', InputTerproses.Opsi1);
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
            writeln('Berhasil tidur');
            hapusKadaluarsa();
            if(SimulasiAktif.JumlahHidup=10)then
            begin
              writeln('Simulasi selesai (10 hari)');
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
          writeln('Berhasil menambah kapasitas inventori menjadi ', SimulasiAktif.Kapasitas);
        end;
      end;

      'lihatresep':begin
        sortResep();
        lihatresep();
      end;

      'help':begin
        writeln('Engi''s Kitchen');
        showHelp();
      end;

      'lihatinventori' : begin
        if(not(isSimulasiAktif))then
        begin
          if (InputTerproses.Opsi1 = '') then
          begin
            write('Nomor Inventori: ');
            readln(InputTerproses.Opsi1);
          end;
          Val(InputTerproses.Opsi1,OpsiAngka,KodeError);
    		  if(KodeError<>0)then
    		  begin
    		    writeln('ERROR : Main -> Nomor inventori harus berupa angka.');
    		  end else
          begin
            loadInventori(InputTerproses.Opsi1);
            if(LoadSukses)then
            begin
              sortArray();
              lihatInventori();
            end else
            begin
              writeln('ERROR : Main -> Load inventori gagal');
            end;

          end;
        end else
        begin
          sortArray();
          lihatInventori();
        end;
      end;

      'cariresep' : begin
        if (InputTerproses.Opsi1 = '') then
        begin
          write('Nama resep: ');
          readln(InputTerproses.Opsi1);
        end;
        formatUserInput(InputTerproses.Opsi1);
        cariResep(InputTerproses.Opsi1);
      end;

      'tambahresep' : begin
        if(InputTerproses.Opsi1 = '') then
        begin
      		write('Nama resep: ');
      		readln(InputTerproses.Opsi1);
    	  end;
        formatUserInput(InputTerproses.Opsi1);
        ResepBaru.Nama := InputTerproses.Opsi1;
        write('Harga: ');
        readln(StringInput);
        Val(StringInput,HargaResep,KodeError);
        if(KodeError<>0) then
        begin
  		    writeln('ERROR : Main -> Harga harus berupa angka');
  		  end else
  		  begin
  		    ResepBaru.Harga := HargaResep;
    			write('Jumlah bahan: ');
    			readln(StringInput);
    			Val(StringInput,OpsiAngka,KodeError);
    			if(KodeError<>0) then
    			begin
    			  writeln('ERROR : Main -> Jumlah bahan harus berupa angka');
  		    end else
  		    begin
    			  ResepBaru.JumlahBahan := OpsiAngka;
    			  writeln('Daftar bahan: ');
            for i := 1 to ResepBaru.JumlahBahan do
            begin
              write('   ', i, '. ');
              readln(ResepBaru.Bahan[i]);
              formatUserInput(ResepBaru.Bahan[i]);
    			  end;
			      tambahResep(ResepBaru, Error);
            if (not(Error)) then
            begin
              writeln('Berhasil menambahkan resep ', ResepBaru.Nama);
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
      writeln('ERROR : Main -> Perintah tidak valid');
      promptPredictor(InputTerproses.Perintah);
    end;


  end;
end.
