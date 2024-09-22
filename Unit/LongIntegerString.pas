unit LongIntegerString;

interface

uses
  SysUtils;

type
  TLongIntegerString = string;

function InitLongIntegerString(Value: string): TLongIntegerString;
procedure LongIntegerAddDigit(var Num: TLongIntegerString; Digit: Char);
function IsDigitsOnly(Num: TLongIntegerString): Boolean;
function LongIntegerAdd(Num1, Num2: TLongIntegerString): TLongIntegerString;
function LongIntegerSubtract(Num1, Num2: TLongIntegerString): TLongIntegerString;
function LongIntegerMultiply(Num1, Num2: TLongIntegerString): TLongIntegerString;
function LongIntegerDivide(Num1, Num2: TLongIntegerString): TLongIntegerString;
function LongIntegerMod(Num1, Num2: TLongIntegerString): TLongIntegerString;

implementation

function InitLongIntegerString(Value: string): TLongIntegerString;
begin
  if IsDigitsOnly(Value)
    then Result := Value;
end;

procedure LongIntegerAddDigit(var Num: TLongIntegerString; Digit: Char);
begin
  if Digit in ['0'..'9']
    then Num := Num + Digit;
end;

function IsDigitsOnly(Num: TLongIntegerString): Boolean;  // Delete 0 left
var
  i: Integer;
begin
  Result := True;
  i := 1;
  while (i < Length(Num)) and Result do
    begin
      if not (Num[i] in ['0'..'9'])
        then Result := False;
      Inc(i);
    end;
end;

function LongIntegerAdd(Num1, Num2: TLongIntegerString): TLongIntegerString;
var
  maxLength1, maxLength2: Integer;
  current: Integer;
  next: Boolean;
  str: string;
begin
  maxLength1 := Length(Num1);
  maxLength2 := Length(Num2);
  next := false;
  str := '';

  while (maxLength1 > 0) or (maxLength2 > 0) do
    begin
      if (maxLength1 > 0) and (maxLength2 > 0)
        then current := StrToInt(Num1[maxLength1]) + StrToInt(Num2[maxLength2])
      else
        if (maxLength1 > 0)
          then current := StrToInt(Num1[maxLength1])
          else current := StrToInt(Num2[maxLength2]);

      if next then
        begin
          Inc(current);
          next := false;
        end;

      if current > 9 then
        begin
          current := current - 10;
          next := True;
        end;

      str := IntToStr(current) + str;

      Dec(maxLength2);
      Dec(maxLength1);
    end;

  if next then
    str := '1' + str;

  Result := InitLongIntegerString(str);
end;

function LongIntegerSubtract(Num1, Num2: TLongIntegerString): TLongIntegerString;
var
  maxLength1, maxLength2: Integer;
  i, j, carry: Integer;
  ResultStr, last: String;

begin
  maxLength1 := Length(Num1);
  maxLength2 := Length(Num2);

  if maxLength1 < maxLength2
    then ResultStr := '-'
    else ResultStr := '';

  last := '';
  carry := 0;
  if maxLength1 > maxLength2 then
    begin
      i := 1;
      while (maxLength1 <> maxLength2) do
        begin
          ResultStr := ResultStr + last;
          last := Num1[i];
          Dec(maxLength1);
          Inc(i);
        end;

      carry := StrToInt(last);
      for j := 1 to maxLength2 do
        begin
          carry := carry * 10 + StrToInt(Num1[i]) - StrToInt(Num2[j]);
          if carry div 10 <> 0
            then ResultStr := ResultStr + IntToStr(carry div 10);
          carry := carry mod 10;
          Inc(i);
        end;

      ResultStr := ResultStr + IntToStr(carry);
    end
  else
    begin
      i := 1;
      while (maxLength1 <> maxLength2) do
        begin
          ResultStr := ResultStr + last;
          last := Num2[i];
          Dec(maxLength2);
          Inc(i);
        end;

      carry := StrToInt(last);
      for j := 1 to maxLength1 do
        begin
          carry := carry * 10 + StrToInt(Num2[i]) - StrToInt(Num1[j]);
          ResultStr := ResultStr + IntToStr(carry div 10);
          carry := carry mod 10;
          Inc(i);
        end;

      ResultStr := ResultStr + IntToStr(carry);
    end;
  Result := ResultStr;
end;

function LongIntegerMultiply(Num1, Num2: TLongIntegerString): TLongIntegerString;
var
  i, j, k: Integer;
  Carry, ProductDigit: Integer;
  countZero: Integer;
  lastSlag, res: string;
begin
  res := '';
  countZero := 0;
  lastSlag := '';
  for i := Length(Num1) downto 1 do
    begin
      res := '';
      Carry := 0;
      for j := Length(Num2) downto 1 do
        begin
          ProductDigit := StrToInt(Num1[i]) * StrToInt(Num2[j]) + Carry;
          Carry := ProductDigit div 10;
          ProductDigit := ProductDigit mod 10;
          res := IntToStr(ProductDigit) + res;
        end;
      if Carry > 0 then
        res := IntToStr(Carry) + res;
      if countZero = 0 then
          lastSlag := res
      else
        begin
          for k := 1 to countZero do
            res := res + '0';
          lastSlag := LongIntegerAdd(lastSlag, res);
        end;
      Inc(countZero);
    end;

  Result := lastSlag;
end;

function LongIntegerDivide(Num1, Num2: TLongIntegerString): TLongIntegerString;
var
  i, j, k, carry, len1, len2: Integer;
  Digit1, Digit2, ResultDigit: Char;
  Temp: String;
begin
  len1 := Length(Num1);
  len2 := Length(Num2);

  // ����������� ����� �����, ����� ������ ����� ���������� �����
  if len1 < len2 then
    Num1 := StringOfChar('0', len2 - len1) + Num1;

  // ��������� ������ ��� ������ ����������
  Result := '';
  
  // ������������� ���������� ��� ����������
  carry := 0; 
  k := 1; // ������� � ������ ����������

  // ���� �� ������ ����� ��������
  for i := 1 to len1 do
  begin
    // ���������� ����� �������� 
    Digit1 := Num1[i];

    // ���� �� ������ ����� ��������
    for j := 1 to len2 do
    begin
      // ���������� ����� ��������
      Digit2 := Num2[j];

      // ���������� ����������
      ResultDigit := Chr((Ord(Digit1) - Ord('0') - carry + Ord(Digit2) - Ord('0')) mod 10 + Ord('0'));

      // ������� 
      if Ord(Digit1) - Ord('0') - carry + Ord(Digit2) - Ord('0') < 0 then
        carry := 1
      else
        carry := 0;

      // ���������� ���������� � ������
      Temp := Result;
      Result := ResultDigit + Temp;

      // ����� ������ ����������
      Result := StringOfChar('0', k - 1) + Result;
      k := k + 1;
    end;

    // ����� ������ ��������
    Num1 := StringOfChar('0', 1) + Num1;
  end;

  // �������� ���������� ����� �� ����������
  while (Result[1] = '0') and (Length(Result) > 1) do
    Result := Copy(Result, 2, Length(Result) - 1);
end;

function LongIntegerMod(Num1, Num2: TLongIntegerString): TLongIntegerString;
var
  i, carry, len1, len2: Integer;
  Digit1, Digit2, ResultDigit: Char;
begin
  len1 := Length(Num1);
  len2 := Length(Num2);

  if len1 < len2 then
    Num1 := StringOfChar('0', len2 - len1) + Num1
  else if len2 < len1 then
    Num2 := StringOfChar('0', len1 - len2) + Num2;

  // ?????????????? ????????? ? carry
  Result := '';
  carry := 0;

  // ?????????? ?????? ???????????, ??????? ? ??????? ????????
  for i := Length(Num1) downto 1 do
  begin
    Digit1 := Num1[i];
    Digit2 := Num2[i];
    ResultDigit := Chr(Ord(Digit1) + Ord(Digit2) + carry - 2 * Ord('0'));

    // ???? ????????? ?????? 9, ????????????? carry
    if Ord(ResultDigit) > Ord('9') then
    begin
      carry := 1;
      ResultDigit := Chr(Ord(ResultDigit) - 10);
    end
    else
      carry := 0;

    // ????????? ????????? ? ?????? ?????? Result
    Result := ResultDigit + Result;
  end;

  // ???? carry ??? ?? ????? 0, ????????? ??? ? ?????? Result
  if carry = 1 then
    Result := '1' + Result;
end;

end.
