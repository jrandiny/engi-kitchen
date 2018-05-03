Program testSimulasi;
uses USimulasi;
var
	error : boolean;
	i : integer;
begin
	error := false;
	startSimulasi(1);
	lihatStatistik();
{	writeln();
	writeln('TESTING Besok');
	tidur(error);
	if not error then begin
		lihatStatistik();
	end;
	writeln();
	writeln('TESTING Besok');
	tidur(error);
	if not error then begin
		lihatStatistik();
	end;}
{	writeln();
	writeln('TESTING PakeEnergi');
	for i := 1 to 9 do begin
		pakeEnergi();
	end;
	lihatStatistik();
	writeln();
	writeln('TESTING Istirahat 2X');
	istirahat();
	lihatStatistik();
	writeln();
	istirahat();
	lihatStatistik();
	writeln();
	writeln('TESTING Makan 4X');
	makan();
	lihatStatistik();
	writeln();
	makan();
	lihatStatistik();
	writeln();
	makan();
	lihatStatistik();
	writeln();
	makan();
	lihatStatistik();
	writeln();
	writeln('TESTING Besok');
	tidur(error);
	if not error then begin
		lihatStatistik();
	end;}
 	writeln();
	writeln('TESTING UbahSTATISTIK');
	ubahStatistik(1,3);
	ubahStatistik(2,1);
	ubahStatistik(3,2);
	ubahStatistik(4,2);
	lihatStatistik();
end.