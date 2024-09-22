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
function LongIntegerSubtract(minuend, subtrahend: TLongIntegerString): TLongIntegerString;
function LongIntegerMultiply(Num1, Num2: TLongIntegerString): TLongIntegerString;
function LongIntegerDivide(dividend, divider: TLongIntegerString): TLongIntegerString;
function LongIntegerMod(dividend, divider: TLongIntegerString): TLongIntegerString;


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

function SubstractWithoutSign(more, less: TLongIntegerString) : TLongIntegerString;
var
  i, j, k, carry, countZero, resLen: Integer;
  last, carryRes, stringResult: String;
  good: Boolean;
begin
  stringResult := '';
  last := '';
  i := 1;
  while ((Length(more)-i+1) <> Length(less)) do
    begin
      stringResult := stringResult + last;
      last := more[i];
      Inc(i);
    end;

  if last <> ''
    then carry := StrToInt(last)
    else carry := 0;

  for j := 1 to Length(less) do
    begin
      carry := carry * 10 + StrToInt(more[i]) - StrToInt(less[j]);
      if carry < 0 then
        begin
          countZero := 0;
          resLen := Length(stringResult);
          carry := 10 + StrToInt(more[i]) - StrToInt(less[j]);
          good := False;
          while not good do
            begin
              if stringResult[resLen-countZero] <> '0' then
                begin
                  carryRes := stringResult[resLen-countZero];
                  stringResult[resLen-countZero] := Chr(Ord(carryRes[1])-1);
                  good := True;
                end
              else
                stringResult[resLen-countZero] := '9';

              Inc(countZero);
            end;
          carry := 90 + carry;
        end;

      if (Length(stringResult) > 0) and (stringResult[1] = '0') then
        begin
          carryRes := '';
          for k := 1 to Length(stringResult)-1 do
            carryRes[k] := stringResult[k+1];
          stringResult := carryRes;
        end;

      if carry div 10 <> 0
        then stringResult := stringResult + IntToStr(carry div 10)
        else if length(stringResult) > 0 then stringResult := stringResult + '0';

      carry := carry mod 10;
      Inc(i);
    end;

  Result := stringResult + IntToStr(carry);
end;

function SignatureDefinition(var longIntStr: TLongIntegerString): Boolean;
var
  carry: TLongIntegerString;
  i: Integer;
begin
  Result := True;
  if (Length(longIntStr) > 0) and (longIntStr[1] = '-') then
    begin
      Result := False;
      carry := '';
      for i := 2 to Length(longIntStr) do
        carry := longIntStr[i];

      longIntStr := carry;
    end;
end;

function LongIntegerSubtract(minuend, subtrahend: TLongIntegerString): TLongIntegerString;
var
  maxLength1, maxLength2: Integer;
  i: Integer;
  more, sign1, sign2, ok: Boolean;
  Temp: TLongIntegerString;
begin
  sign1 := SignatureDefinition(minuend);
  sign2 := SignatureDefinition(subtrahend);

  if (sign1 and not sign2)
    then Result := LongIntegerAdd(minuend, subtrahend)
  else
  if (not sign1 and sign2)
    then Result := '-' + LongIntegerAdd(minuend, subtrahend)
  else
    if (sign1 and sign2) then
      begin
        maxLength1 := Length(minuend);
        maxLength2 := Length(subtrahend);

        if maxLength1 < maxLength2
          then Result := '-' + SubstractWithoutSign(subtrahend, minuend)
        else
          if maxLength1 = maxLength2 then
            begin
              more := true;
              ok := true;
              i := 1;
              while ok and (i <= maxLength1) do
                begin
                  if (Ord(minuend[i]) <> Ord(subtrahend[i])) then
                    begin
                      more := Ord(minuend[i]) > Ord(subtrahend[i]);
                      ok := false;
                    end;
                  Inc(i)
                end;
              if more
                then Result := SubstractWithoutSign(minuend, subtrahend)
                else Result := '-' + SubstractWithoutSign(subtrahend, minuend);
            end
          else Result := SubstractWithoutSign(minuend, subtrahend);
      end
    else
      begin
        Temp := minuend;
        minuend := subtrahend;
        subtrahend := Temp;

        maxLength1 := Length(minuend);
        maxLength2 := Length(subtrahend);

        if maxLength1 < maxLength2
          then Result := '-' + SubstractWithoutSign(subtrahend, minuend)
        else
          if maxLength1 = maxLength2 then
            begin
              more := true;
              ok := true;
              i := 1;
              while ok and (i <= maxLength1) do
                begin
                  if (Ord(minuend[i]) <> Ord(subtrahend[i])) then
                    begin
                      more := Ord(minuend[i]) > Ord(subtrahend[i]);
                      ok := false;
                    end;
                  Inc(i)
                end;
              if more
                then Result := SubstractWithoutSign(minuend, subtrahend)
                else Result := '-' + SubstractWithoutSign(subtrahend, minuend);
            end
          else Result := SubstractWithoutSign(minuend, subtrahend);
      end;
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

function LongIntegerDivide(dividend, divider: TLongIntegerString): TLongIntegerString;
var
  i, j, dot, current, dividendLen, dividerLen, lenRes: Integer;
  currentDividend, remainder: TLongIntegerString;
  more, endWhile, ok: Boolean;
begin
  dividendLen := Length(dividend);
  dividerLen := Length(divider);

  Result := '';
  currentDividend := '';
  remainder := '';
  dot := 0;
  endWhile := True;
  i := 1;
  while endWhile do
    begin
      currentDividend := remainder;
      more := True;
      if currentDividend = '0' then currentDividend := '';
      while Length(currentDividend) <> dividerLen do
        begin
          if i > dividendLen then
            begin
              currentDividend := currentDividend + '0';
              Inc(dot);
            end
          else currentDividend := currentDividend + dividend[i];

          if more
            then more := dividend[i] > divider[i];

          Inc(i);
        end;

      if Length(currentDividend) < Length(divider) then
        begin
          ok := true;
          j := 1;
          while (j < dividerLen) and ok do
            begin
              if (Ord(currentDividend[j]) <> Ord(divider[j])) then
                begin
                  more := Ord(currentDividend[j]) > Ord(divider[j]);
                  ok := false;
                end;
              Inc(j)
            end;

          if not more then
            if i > dividendLen then
              begin
                currentDividend := currentDividend + '0';
                Inc(dot);
              end
            else
              begin
                currentDividend := currentDividend + dividend[i];
                Inc(i);
              end;
        end;

      remainder := LongIntegerSubtract(currentDividend, divider);
      current := 1;
      while LongIntegerSubtract(remainder, divider)[1] <> '-' do
        begin
          Inc(current);
          remainder := LongIntegerSubtract(remainder, divider);
        end;

      endWhile := not ((i > dividendLen) and (remainder = '0'));

      Result := Result + IntToStr(current);
    end;

  if dot > 0 then
    begin
      lenRes := Length(Result);
      if lenRes = dot
        then Result := '0,' + Result
      else
        begin
          currentDividend := ',';
          for i := 1 to dot do
            currentDividend := currentDividend + Result[lenRes-i+1];
          for i := 1 to lenRes - dot do
            currentDividend := currentDividend + Result[i];
        end;
    end;
end;

function LongIntegerMod(dividend, divider: TLongIntegerString): TLongIntegerString;
var
  i, j, dot, current, dividendLen, dividerLen, lenRes: Integer;
  currentDividend, remainder: TLongIntegerString;
  more, endWhile, ok: Boolean;
begin
  dividendLen := Length(dividend);
  dividerLen := Length(divider);

  Result := '';
  currentDividend := '';
  remainder := '';
  dot := 0;
  endWhile := True;
  i := 1;
 while endWhile do
    begin
      currentDividend := remainder;
      more := True;
      if currentDividend = '0' then currentDividend := '';
      while Length(currentDividend) <= dividerLen do
        begin
          if i > dividendLen then
            begin
              endWhile := False;
            end
          else currentDividend := currentDividend + dividend[i];

          if more
            then more := dividend[i] > divider[i];

          Inc(i);
        end;

      if Length(currentDividend) < Length(divider) then
        begin
          ok := true;
          j := 1;
          while (j < dividerLen) and ok do
            begin
              if (Ord(currentDividend[j]) <> Ord(divider[j])) then
                begin
                  more := Ord(currentDividend[j]) > Ord(divider[j]);
                  ok := false;
                end;
              Inc(j)
            end;

          if not more then
            if i > dividendLen then
              begin
                endWhile := False;
              end
            else
              begin
                currentDividend := currentDividend + dividend[i];
                Inc(i);
              end;
        end;

      remainder := currentDividend;
      if endWhile then
        begin
          remainder := LongIntegerSubtract(currentDividend, divider);
          current := 1;
          while LongIntegerSubtract(remainder, divider)[1] <> '-' do
            begin
              Inc(current);
              remainder := LongIntegerSubtract(remainder, divider);
            end;
        end;

      endWhile := not (i > dividendLen);

      Result := remainder;
    end;
end;

end.
