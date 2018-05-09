Unit UResep;

interface

Uses UInventori,UTipe,sysutils,math;

	var
		ResepResep : DaftarResep;


	function idxNamaResep(str : string) : integer;
	{menerima nama resep (str) yang ingin diketahui indeksnya pada Daftar Resep
  terdefinisi. Mengembalkan indeks dari nama resep (str)}

	function isResepAda(str : string) : boolean;
	{Menerima nama resep yang mau dicari dan daftar resep terdefinisi.
  Menghasilkan true jika nama resep ada di daftar resep dan false jika tidak ada}

	procedure sortResep();
	{I.S : ResepResep terdefinisi}
	{F.S : mengurutkan ResepResep yang berisi daftar nama resep yang terurut abjad}

	procedure tambahResep(input:Resep; var Error:boolean);
	{I.S : nama resep dan bahan penyusunnya terdefinisi di ResepResep}
	{F.S : daftar resep bertambah jika input valid, Error true saat input tidak valid}

	procedure cariResep(NamaResep : string);
	{I.S : ResepResep terdefinisi dan diinput NamaResep}
	{F.S : jika nama resep ditemukan menampilkan nama resep, nama bahan penyusun, dan harga jual resep}

	procedure lihatResep;
  {I.S : ResepResep terdefinisi}
	{F.S : menampilkan daftar resep dan daftar bahan penyusunnya}

	function jualResep(Hidangan: string):longint;
  {Menerima input nama hidangan. Lalu mengurangi inventori, menambah pemasukan,
  dan mengurangi energi jika bahan untuk mengolah hidangan ada. Output yang
   dihasilkan adalah harga resep jika dijual, jika gagal akan bernilai -1}


Implementation

	{Fungsi untuk mencari indeks Nama Resep}
	function idxNamaResep(str : string) : integer;
	{Kamus Lokal}
	var
		i: integer;
	{Algoritma function idxNamaResep}
	begin
		i := 1;
    {loop sampai habis atau ketemu}
		while ((i<= ResepResep.Neff) and (ResepResep.Isi[i].Nama <> str)) do
		begin
			i:=i+1;
		end;

    {cek apakah ketemu}
		if (ResepResep.Isi[i].Nama = str) then
		begin
			idxNamaResep:=i;
		end else
		begin
			idxNamaResep:=0;
		end;
	end;

	{Fungsi untuk mengecek apakah nama resep ada pada daftar resep}
	function isResepAda(str : string) : boolean;

	{Algoritma function IsResepAda}
	begin
		if (idxNamaResep(str) <> 0) then
		begin
			isResepAda:=true;
		end else
		begin
			isResepAda:=false;
		end;
	end;

	// Prosedur untuk mengurutkan nama resep dengan urutan membesar
	procedure sortResep();
	{Kamus Lokal}
	var
		b, k, N : integer;
		temp : Resep;
	{Algoritma procedure sortResep}
	begin
    if(not(ResepResep.Sorted))then
    begin
      {Bubble sort}
  		N := ResepResep.Neff;
  		if (N>1) then
  		begin
  			for b:=1 to N do
  			begin
  				for k:=N downto b+1 do
  				begin
  					if (ResepResep.Isi[k].Nama < ResepResep.Isi[k-1].Nama) then
  					begin
  						temp := ResepResep.Isi[k];
  						ResepResep.Isi[k] := ResepResep.Isi[k-1];
  						ResepResep.Isi[k-1] := temp;
  					end;
  				end;
  			end;
  		end;
    end;

    ResepResep.Sorted := true;

	end;

	// Proedur untuk menambah resep
	procedure tambahResep(input:Resep; var Error:boolean);
	{Kamus Lokal}
	var
		i : integer;
    InputValid:boolean;
    IsBahanAda:boolean;
    HargaBahan:longint;
    IndeksBahan:integer;
	{Algoritma procedure TambahResep}
	begin
		Error := false;
    {cek apa sudah ada dengan nama sama}
		if (isResepAda(input.Nama)) then
		begin
      write('ERROR : UResep -> Resep dengan nama');
      write(input.nama);
      writeln('sudah ada');
			Error := true;
		end else
		begin
      InputValid := true;
      HargaBahan:=0;

      for i:=1 to input.JumlahBahan do
      begin
        IsBahanAda:=false;

        {cek apa bahan ada}
        IndeksBahan := searchIndex(input.Bahan[i],'DM');

        if(IndeksBahan<>-1)then
        begin
          IsBahanAda:=true;
          HargaBahan:=HargaBahan + DaftarBahanM.Isi[IndeksBahan].Harga;
        end;

        IndeksBahan := searchIndex(input.Bahan[i],'DO');

        if(IndeksBahan<>-1)then
        begin
          IsBahanAda:=true;
          HargaBahan:=HargaBahan + DaftarBahanO.Isi[IndeksBahan].Harga;
        end;

        InputValid:=InputValid and IsBahanAda;

        if(not(IsBahanAda))then
        begin
          write('ERROR : UResep -> Ada bahan yang tidak terdaftar (');
          write(input.Bahan[i]);
          writeln(')');
					Error := true;
        end;
      end;

      {cek harga}
      if(input.Harga<ceil(1125/1000*HargaBahan))then
      begin
        InputValid:=false;
        writeln('ERROR : UResep -> Harga kurang dari 112,5% harga bahan',ceil(1125/1000*HargaBahan));
				Error := true;
      end;



      if(InputValid)then
      begin
        {tambah resep jika valid}
        ResepResep.Neff := ResepResep.Neff +1;
  			ResepResep.Isi[ResepResep.Neff].Nama := input.Nama;
  			ResepResep.Isi[ResepResep.Neff].Harga := input.Harga;
  			ResepResep.Isi[ResepResep.Neff].JumlahBahan := input.JumlahBahan;
        for i:=1 to input.JumlahBahan do
        begin
          ResepResep.Isi[ResepResep.Neff].Bahan[i] := input.Bahan[i];
        end;

        ResepResep.Sorted:=false;
      end;
		end;

	end;

	//Prosedur untuk mencari nama resep
	procedure cariResep(NamaResep : string);
	{Kamus Lokal}
	var
		i, j, Neff : integer;
	{Algoritma procedure CariResep}
	begin
    {jika ada}
		if (isResepAda(NamaResep)) then
		begin
      {cari indeksnya}
      i:=idxNamaResep(NamaResep);
      Neff := ResepResep.Isi[i].JumlahBahan;

      {tampilkan}
      write('Nama  : ');
			writeln(NamaResep);
      write('Harga : ');
      writeln(ResepResep.Isi[i].Harga);
      write('Bahan : ');
      writeln(Neff);

			for j:=1 to Neff do
			begin
        write(j);
        write('. ');
				writeln(ResepResep.Isi[i].Bahan[j]);
			end;
		end else
    begin
      write('ERROR : UResep -> Resep dengan nama ');
      write(NamaResep);
      writeln(' tidak ada');
    end;
	end;

	// Prosedur untuk melihat daftar resep beserta bahan penyusunnya
	procedure lihatResep;
	{Kamus Lokal}
	var
		i,k : integer;

	{Algoritma procedure LihatResep}
	begin
		writeln('----------------------DAFTAR RESEP----------------------');
		writeln('NAMA RESEP          HARGA       JUMLAH      BAHAN       ');
		for i := 1 to ResepResep.Neff do
		begin
			write(Format('%-20s',[ResepResep.Isi[i].Nama]));
			write(Format('%-12d',[ResepResep.Isi[i].Harga]));
			write(Format('%-12d',[ResepResep.Isi[i].JumlahBahan]));
			for k:= 1 to ResepResep.Isi[i].JumlahBahan do
			begin
				write(ResepResep.Isi[i].Bahan[k]);
        if(k<>ResepResep.Isi[i].JumlahBahan)then
        begin
          write(', ');
        end;

			end;
			writeln();
		end;
	end;

	function jualResep(Hidangan : string):longint;
	var
			adaresep, adabahan : boolean;
			indeks,Neff : integer;
      isError:boolean;
      j:integer;
      HasilUang : longint;

		begin
      HasilUang:=-1;
			adaresep := IsResepAda(Hidangan);
      {cek resep ada}
			if (adaresep) then
			begin
				indeks := idxNamaResep(Hidangan);
				adabahan := true;

        Neff := ResepResep.Isi[indeks].JumlahBahan;

        {cek apa ada bahan yang diperlukan}
  			for j:=1 to Neff do
  			begin
          if(not(IsBahanAda(ResepResep.Isi[indeks].Bahan[j])))then
          begin
            write('ERROR : UResep -> Ada bahan yang tidak ada (');
            write(ResepResep.Isi[indeks].Bahan[j]);
            writeln(')');
            adabahan:=false;
          end;
  			end;

				if (adabahan) then
				begin
          {jika ada bahan kurangi bahannya}
          HasilUang:=ResepResep.Isi[indeks].Harga;
          for j:=1 to Neff do
    			begin
  			    kuranginBahan(ResepResep.Isi[indeks].Bahan[j],isError);
    			end;
				end;



			end else
      begin
        write('ERROR : UResep -> Tidak ada resep bernama ');
        writeln(Hidangan);
      end;
        jualResep:=HasilUang;
		end;

end.
