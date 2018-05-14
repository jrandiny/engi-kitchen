program TestUI;

uses UUI;

var
  a:string;

begin
  writeError('TestUI','Testing writeError');
  writeLog('TestUI','Testing writeLog');
  writeText('Testing writeText');
  writelnText('Testing writelnText');
  readText(a);
  writelnText(a);
end.
