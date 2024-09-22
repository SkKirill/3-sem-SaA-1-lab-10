program ProjectTestLongIntegerString;

{$APPTYPE CONSOLE}

uses
  SysUtils, LongIntegerString;


var
  TestStringInteger: TLongIntegerString;
begin
  // InitLongIntegerString
  Write('InitLongIntegerString: ');
  TestStringInteger := InitLongIntegerString('12345');
  if TestStringInteger = '12345' then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerAddDigit
  Write('LongIntegerAddDigit: ');
  LongIntegerAddDigit(TestStringInteger, '4');
  if TestStringInteger = '123454' then
    WriteLn('success')
  else
    WriteLn('error');

  // IsDigitsOnly
  Write('IsDigitsOnly: ');
  if IsDigitsOnly('12345') then
    WriteLn('success')
  else
    WriteLn('error');

  Write('not IsDigitsOnly: ');
  if not IsDigitsOnly('123a45') then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerAdd
  Write('LongIntegerAdd: ');
  if LongIntegerAdd('12345', '31055') = '43400' then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerSubtract
  Write('LongIntegerSubtract: ');
  if LongIntegerSubtract('12345', '6789') = '5556' then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerMultiply
  Write('LongIntegerMultiply: ');
  if LongIntegerMultiply('123', '456') = '56088' then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerDivide
  Write('LongIntegerDivide: ');
  if LongIntegerDivide('12345', '6789') = '1' then
    WriteLn('success')
  else
    WriteLn('error');

  // LongIntegerMod
  Write('LongIntegerMod: ');
  if LongIntegerMod('12345', '6789') = '5556' then
    WriteLn('success')
  else
    WriteLn('error');

  ReadLn;
end.
