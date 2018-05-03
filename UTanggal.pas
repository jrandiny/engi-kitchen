unit UTanggal;

interface

  uses UTipe;

  function getTanggal(Input:string):Tanggal;
  {Menerima Input string tanggal dalam format dd/mm/yy lalu isi ke bentuk
  variabel Tanggal}

  function nextTanggal(Input:Tanggal):Tanggal;
  {Mengembalikan tipe data Tanggal dari Input yang telah dimajukan 1 hari}

  function selisihTanggal(Input1:Tanggal; Input2:Tanggal):integer;
  {Mengembalikan jarak dalam hari antara 2 tanggal, asumsi Input1 lebih duluan}

  function isTanggalSama(Input1:Tanggal; Input2:Tanggal):boolean;
  {Mengembalikan apakah tanggal Input1  dan Input2 sama}

  function isTanggalDuluan(Input1:Tanggal; Input2:Tanggal):Boolean;
  {mencari tanggal mana yang lebih duluan, akan bernilai true saat Input1 lebih dahulu
  dari Input2}


implementation

function isTanggalSama(Input1:Tanggal; Input2:Tanggal):boolean;

{kamus lokal}
var
  Sama:boolean;

{Algoritma - isTanggalSama}
begin
  {cek apkah sama hari, bulan dan tahunnya}
  Sama := Input1.Hari = Input2.Hari;
  if(sama)then
  begin
    Sama := Sama and (Input1.Bulan = Input2.Bulan);
    if(sama)then
    begin
      Sama := Sama and (Input1.Tahun = Input2.Tahun);
    end;
  end;

  isTanggalSama := Sama;
end;

function maxHari(Input:Tanggal):integer;
{Kamus}
var
  x:Tanggal;
{Algoritma}
begin
  x:=Input;
  case (x.Bulan) of
    1 : begin
      MaxHari:=31;
    end;
    2 :begin
      {cek kabisat sederhana}
      if (x.Tahun mod 4 = 0) then
        begin
          if(x.Tahun mod 100 = 0)then
          begin
            if(x.Tahun mod 400 = 0)then
            begin
              {habis dibagi 400 =  kabisat}
              MaxHari:=29;
            end else
            begin
              {tidak habus dibagi 400 tapi bisa dibagi 100}
              MaxHari:=28;
            end;
          end else
          begin
            {Habis dibagi 4 tapi tidak habis dibagi 100 =  kabisat}
            MaxHari:=29;
          end;
        end else
        begin
          {tidak habis dibagi 4}
          MaxHari:=28;
        end;
    end;
    3 : begin
      MaxHari:=31;
    end;
    4 :begin
      MaxHari:=30;
    end;
    5 : begin
      MaxHari:=31;
    end;
    6 :begin
      MaxHari:=30;
    end;
    7 : begin
      MaxHari:=31;
    end;
    8 :begin
      MaxHari:=31;
    end;
    9 : begin
      MaxHari:=30;
    end;
    10 :begin
      MaxHari:=31;
    end;
    11 : begin
      MaxHari:=30;
    end;
    12 :begin
      MaxHari:=31;
    end;
  end;
end;

function getTanggal(Input:string):Tanggal;
{Kamus}
var
  i : integer;
  str : string; //string sementara
  indeks : integer;
  x:Tanggal; //variabel sementara Tanggal
  KodeError:integer;

{Algoritma}
begin

  indeks:=1;
  str := '';
  while (indeks<=3) do
    begin
      {iterasi sampai akhir}
      for i:=1 to length(Input) do
        begin
          {Cek apakah karakter pemisah}
          if (Input[i]='/') then
            begin
              indeks:=indeks+1;
              str := ''; {str direset biar diisi sama yang baru}
            end else
            begin
              {set string sementara}
              str := str + Input[i];
              if (indeks=1) then {indeks 1 = hari}
                begin
                  {ubah ke integer}
                  Val(str,x.Hari,KodeError);
                  if(KodeError<>0)then
                  begin
                    writeln('ERROR : UTanggal -> Hari bukan integer');
                  end;
                end else
              if (indeks=2) then {indeks 2 = bulan}
                begin
                  {ubah ke integer}
                  Val(str,x.Bulan,KodeError);
                  if(KodeError<>0)then
                  begin
                    writeln('ERROR : UTanggal -> Bulan bukan integer');
                  end else
                  begin
                    {cek bulan valid}
                    if (x.Bulan>12) or (x.Bulan<1) then
                    begin
                      writeln('ERROR : UTanggal -> Bulan tidak valid');
                    end;
                  end;
                end else {indeks 3 = tahun}
                begin
                  {ubah ke integer}
                  Val(str,x.Tahun,KodeError);
                  if(KodeError<>0)then
                  begin
                    writeln('ERROR : UTanggal -> Tahun bukan integer');
                  end else
                  begin
                    {cek tahun valid}
                    if (x.Tahun<0) then
                    begin
                      writeln('ERROR : UTanggal -> Tahun tidak valid');
                    end;
                  end;
                end;
            end;
        end;
    end;
    {cek hari valid sesuai bulan}
    if (x.Hari>MaxHari(x)) or (x.Hari<1) then
    begin
      writeln('ERROR : UTanggal -> Hari tidak valid');
    end;
    getTanggal:=x;
end;

  function nextTanggal(Input:Tanggal):Tanggal;
  {Kamus}
  var
  x:Tanggal; {tanggal yang didapat dari getTanggal}
  y:Tanggal; {variabel tanggal sementara untuk nextTanggal}
  {Algoritma}
  begin
    x:=Input;
    {Kasus khusus jika bulan 12 (bisa ganti tahun)}
    if (x.Bulan=12) then
    begin
      if (x.Hari=MaxHari(Input)) then
      begin
        {Ganti tahun}
        y.Tahun:=x.Tahun+1;
        y.Bulan:=1;
        y.Hari:=1;
      end else
      begin
        y.Hari:=x.Hari+1;
        y.Tahun:=x.Tahun;
        y.Bulan:=x.Bulan;
      end;
    end else
    if (x.Hari=MaxHari(Input)) then
    begin
      y.Tahun:=x.Tahun;
      y.Bulan:=x.Bulan+1;
      y.Hari:=1;
    end else
    begin
      y.Hari:=x.Hari+1;
      y.Tahun:=x.Tahun;
      y.Bulan:=x.Bulan;
    end;

    nextTanggal:=y;
  end;

  function selisihTanggal(Input1:Tanggal; Input2:Tanggal):integer;

  {Kamus Lokal}
  var
    jarak:integer;

  {Algoritma - selisihTanggal}
  begin
    jarak:=0;
    {terus ulangi sampai tanggal sama}
    while((Input1.Hari<>Input2.Hari) or (Input1.Bulan<>Input2.Bulan) or (Input1.Tahun<>Input2.Tahun)) do
    begin
      {next tanggal sampai sama}
      Input1:=nextTanggal(Input1);
      jarak:=jarak+1;
    end;
    selisihTanggal:=jarak;
  end;

function isTanggalDuluan(Input1:Tanggal; Input2:Tanggal):Boolean;

{Kamus lokal}
var
	x,y : Tanggal; //x adalah Input1, y adalah Input2
	hasil : Boolean; //variabel sementara isTanggalDuluan

{Algoritma}
begin
x:=Input1; y:=Input2;

{cek tanggal duluan mulai dari tahun sampai hari}
if (x.Tahun > y.Tahun) then
	begin
	hasil:=False;
	end
else if (x.Tahun < y.Tahun) then
	begin
	hasil:=True;
	end
else {x.Tahun = y.Tahun}
	begin
	if (x.Bulan > y.Bulan) then
		begin
		hasil:=False;
		end
	else if (x.Bulan < y.Bulan) then
		begin
		hasil:=True;
		end
	else {x.Bulan = y.Bulan}
		begin
		if (x.Hari >= y.Hari) then
			begin
			hasil:=False;
			end
		else if (x.Hari < y.Hari) then
			begin
			hasil:=True;
			end;
		end;
	end;

isTanggalDuluan:=hasil;
end;

end.
