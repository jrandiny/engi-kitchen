unit USimulasi;

interface
uses
	UTipe, UFile, UTanggal,UUI,sysutils;
var
	SimulasiAktif : Simulasi;
  SemuaSimulasi : DaftarSimulasi;

  procedure tambahEnergi(Jumlah : integer);
  {I.S. : Terdefinisi SimulasiAktif dan menerima jumlah energi yang akan ditambah}
  {F.S. : Energi ditambah sebanyak jumlah}

  procedure pakeEnergi(var Error : boolean);
  {I.S. :Terdefinisi SimulasiAktif}
  {F.S. : Energi sudah dikurang satu dan Error menjadi false atau  menampilkan
  pesan kesalahan dan Error menjadi true}

  procedure makan();
  {I.S. : Makan belum dilakukan}
  {F.S. : banyakMakan bertambah satu dan energi bertambah tiga atau menampilkan pesan kesalahan}

  procedure istirahat();
  {I.S. : Istirahat belum dilakukan}
  {F.S. : banyakIstirahat bertambah satu dan energi bertambah satu atau menampilkan
  pesan kesalahan jika sudah mencapai limit}

  procedure tidur(var Error : boolean);
  {I.S. : Terdefinisi SimulasiAktif}
  {F.S. : Energi menjadi 10, hari menjadi besok, dan Error menjadi false atau
  menampilkan pesan kesalahan dan Error menjadi true}

  procedure startSimulasi(NomorSimulasi : integer;var Error:boolean);
  {I.S. : Menerima NomorSimulasi yang akan dicek di daftar simulasi}
  {F.S. : Terdefinisi SimulasiAktif sesuai dengan nomor yang diinput atau menampilkan
  pesan kesalahan jika nomor tidak ada, variabel Error juga akan menjadi true}

  procedure tambahUang(Jumlah : longint);
  {I.S. : terdefinisi SimulasiAktif dan menerima jumlah uang yang akan ditambah}
  {F.S. : Uang akan ditambah sebanyak jumlah}

  procedure pakaiUang(Jumlah : longint; var Error : boolean );
  {I.S. : terdefinisi SimulasiAktif dan menerima jumlah yang ingin dikurangi}
  {F.S. : Uang akan berkurang sebanyak jumlah dan Error menjadi false atau
  menampilkan pesan kesalahan dan Error menjadi true}

  procedure besok();
  {I.S. : Terdefinisi tanggal hari ini di SimulasiAktif}
  {F.S. : Tanggal menjadi besok}

  procedure lihatStatistik();
  {I.S. : terdefinisi variabel SimulasiAktif yang merupakan simulasi yang sedang berjalan}
  {F.S. : Menampilkan statistik simulasi yang sedang berjalan}

  procedure ubahStatistik(Jenis,Jumlah : integer);
  {I.S. : terdefinisi SimulasiAktif dan menerima nomor kode statistik yang ingin diubah dan jumlahnya}
  {F.S. : Mengubah statistik yang sesuai kode sebanyak jumlah.
  Kode:
  1 = jumlah mentah dibeli
  2 = jumlah bahan diolah
  3 = jumlah olahan dijual
  4 = jumlah resep dijual}

  procedure upgradeInventori(var Error:boolean);
  {I.S : Terdefinisi SimulasiAktif}
  {F.S : Menambah nilai kapasitas jika syarat terpenuhi. Jika tidak, maka nilai
  kapasitas tidak berubah dan Error bernilai true}

  function simulasiAda(NomorSimulasi :integer):integer;
  {Cek apakah nomor simulasi valid}
  {Mengembalikan -1 saat tidak menemukan}


implementation

	{KAMUS LOKAL}
  var
	   BanyakIstirahat,BanyakMakan : integer;

  procedure upgradeInventori(var Error:boolean);

  {ALGORITMA upgrade}
  begin
    Error := false;
    {Jika cukup uang}
    if(SimulasiAktif.TotalUang > HARGAUPGRADE)then
    begin
      {tambah kapasitas}
      SimulasiAktif.Kapasitas:= SimulasiAktif.Kapasitas + 25;
    end else
    begin
      Error := true;
      writeError('USimulasi','Tidak cukup uang untuk upgrade');
    end;

  end;


  procedure tambahEnergi(Jumlah : integer);

  {Algoritma - tambahEnergi}
  begin
	  SimulasiAktif.Energi := SimulasiAktif.Energi + jumlah;
    {energi tidak boleh >10}
    if (SimulasiAktif.Energi > 10) then
    begin
		  SimulasiAktif.Energi := 10;
	  end;
  end;

  procedure pakeEnergi(var Error : boolean);

  {Algoritma - pakeEnergi}
  begin
    {energi tidak boleh <0}
	  if ((SimulasiAktif.Energi - 1) >= 0) then
    begin
      Error := false;
		  SimulasiAktif.Energi := SimulasiAktif.Energi - 1;
	  end else
    begin
      Error := true;
      writeError('USimulasi','Energi sudah habis');
	  end;
  end;

  procedure makan();

  {Algoritma - makan}
  begin
    {makan maksimal 3 kali}
	  if (BanyakMakan < 3) then
    begin
		  tambahEnergi(3);
		  BanyakMakan := BanyakMakan + 1;
	  end else
    begin
      writeError('USimulasi','Jatah makan sudah habis');
	  end;
  end;

  procedure istirahat();

  {Algoritma - istirahat}
  begin
    {istirahat maksimal 6 kali}
	  if (banyakIstirahat < 6) then
    begin
		  tambahEnergi(1);
		  BanyakIstirahat := BanyakIstirahat + 1;
	  end else
    begin
      writeError('USimulasi','Jatah istirahat sudah habis');
    end;
  end;

  procedure tidur(var Error : boolean);

  {Algoritma - tidur}
  begin
    Error := false;
    {hanya boleh tidur jika sudah melakukan kegiatan}
	  if (((banyakIstirahat <> 0) or (banyakMakan <> 0)) or (SimulasiAktif.Energi <> 10)) then
    begin
		  SimulasiAktif.Energi := 10;
	    besok();
	  	BanyakIstirahat := 0;
		  BanyakMakan := 0;
	  	SimulasiAktif.JumlahHidup := SimulasiAktif.JumlahHidup + 1;
	  end else
    begin
		  Error := true;
      writeError('USimulasi','Tidur dapat dilakukan setelah melakukan minimal satu aksi lain');
	  end;
  end;

  function simulasiAda(NomorSimulasi :integer):integer;

  {KAMUS LOKAL}
  var
    Ada:boolean;
    Indeks:integer;

  {Algoritma - simulasiAda}
  begin
    Indeks:=1;
    Ada := false;
    {cari simulasi dengan nomor sesuai (kaena nomor simulasi bisa tidak berurut)}
  	while ((Indeks <= SemuaSimulasi.Neff) and (not Ada)) do
    begin
  		if (SemuaSimulasi.Isi[indeks].Nomor = NomorSimulasi) then
      begin
  			Ada := true;
  		end;
      Indeks:=Indeks+1;
  	end;

    if Ada then
    begin
      Indeks := Indeks -1;
    end else
    begin
      Indeks := -1;
    end;

    simulasiAda:=Indeks;
  end;

  procedure startSimulasi(NomorSimulasi : integer; var ERROR:boolean);

  {KAMUS LOKAL}
  var
  	Indeks : integer;

  {Algoritma - startSimulasi}
  begin
    ERROR := false;

    Indeks := simulasiAda(NomorSimulasi);

  	if (Indeks<>-1) then
    begin
      {cek apa sudah selesai simulasinya (hari ke 10)}
      if(SemuaSimulasi.Isi[Indeks].JumlahHidup<10)then
      begin
        writelnText('Mulai simulasi '+IntToStr(Nomorsimulasi));
        SimulasiAktif := SemuaSimulasi.Isi[Indeks];
        banyakIstirahat := 0;
        banyakMakan := 0;
      end else
      begin
        writelnText('Simulasi sudah selesai');
        Error:=true;
      end;

  	end else
    begin
      writeError('USimulasi','Nomor simulasi tidak ditemukan');
      ERROR := true;
  	end;
  end;


  procedure tambahUang(Jumlah : longint);

  {Algoritma - tambahUang}
  begin
	  SimulasiAktif.TotalUang := SimulasiAktif.TotalUang + Jumlah;
	  SimulasiAktif.Pemasukan := SimulasiAktif.Pemasukan + Jumlah;
  end;


  procedure pakaiUang(Jumlah : longint; var Error : boolean);

  {Algoritma - pakaiUang}
  begin
    {cukup uang atau tidak}
	  if ((SimulasiAktif.TotalUang - Jumlah) >= 0) then
    begin
      Error := false;
		  SimulasiAktif.TotalUang := SimulasiAktif.TotalUang - Jumlah;
		  SimulasiAktif.Pengeluaran := SimulasiAktif.Pengeluaran + Jumlah;
	  end else
    begin
      Error := true;
      writeError('USimulasi','Uang tidak cukup');
	  end;
  end;

  procedure besok();

  {Algoritma - besok}
  begin
	  SimulasiAktif.Tanggal := nextTanggal(SimulasiAktif.Tanggal);
  end;

  procedure lihatStatistik();

  {Algoritma - lihatStatistik}
  begin
	  writelnText('Nomor Simulasi    : '+ IntToStr(SimulasiAktif.Nomor));
	  writelnText('Tanggal           : '+ IntToStr(SimulasiAktif.Tanggal.Hari)+ '/'+ IntToStr(SimulasiAktif.Tanggal.Bulan)+ '/'+ IntToStr(SimulasiAktif.Tanggal.Tahun));
    writelnText('Jumlah Hari Hidup : '+ IntToStr(SimulasiAktif.JumlahHidup));
	  writelnText('Jumlah Energi     : '+ IntToStr(SimulasiAktif.Energi));
    writelnText('');
	  writelnText('Kapasitas Maksimum Inventori : '+ IntToStr(SimulasiAktif.Kapasitas));
    writelnText('');
	  writelnText('Total Bahan Mentah Dibeli : '+ IntToStr(SimulasiAktif.BeliMentah));
	  writelnText('Total Bahan Olahan Dibuat : '+ IntToStr(SimulasiAktif.BuatOlahan));
	  writelnText('Total Bahan Olahan Dijual : '+ IntToStr(SimulasiAktif.JualOlahan));
	  writelnText('Total Resep Dijual        : '+ IntToStr(SimulasiAktif.JualResep));
    writelnText('');
	  writelnText('Total Pemasukan   : '+ IntToStr(SimulasiAktif.Pemasukan));
	  writelnText('Total Pengeluaran : '+ IntToStr(SimulasiAktif.Pengeluaran));
	  writelnText('Total Uang        : '+ IntToStr(SimulasiAktif.TotalUang));
  end;

  procedure ubahStatistik(Jenis, Jumlah : integer);

  {Algoritma - ubahStatistik}
  begin
	  case (Jenis) of
		  1 : begin
			  SimulasiAktif.BeliMentah := SimulasiAktif.BeliMentah + Jumlah;
		  end;
		  2 : begin
			  SimulasiAktif.BuatOlahan := SimulasiAktif.BuatOlahan + Jumlah;
		  end;
		  3 : begin
			  SimulasiAktif.JualOlahan := SimulasiAktif.JualOlahan + Jumlah;
		  end;
		  4 : begin
			  SimulasiAktif.JualResep := SimulasiAktif.JualResep + Jumlah;
		  end;
	  end;
  end;

end.
