### Скоморохов Кирилл | 8 (900) 988-75-37 | Т-Банк | tg = @sk_kiriII  | vk = sk_kirill | Delphi7 | Pascal

> **Стоимость - 1200₽**

# Задача 10

Создать модуль, реализующий представление длинного целого числа в виде строки символов,  
а так же операции:
- сложения
- вычитания
- умножения
- деления нацело
- нахождение остатка от деления нацело

# Как использовать модуль:
  
### Папка `Unit`
1. Для просмотра лабы ее нужно скачать и открыть файл `ProjectLongIntegerString.dpr`  
2. После этого открыть файл `LongIntegerString.pas`  
3. Можно нажать кнопку билда (зеленый треугольник `Run`)  

### Папка `Test`
1. Запускаем консольное приложение `ProjectTestLongIntegerString.dpr`
2. Можно нажать кнопку билда (зеленый треугольник `Run`) и наслаждаться процессом тестирования!
> [!CAUTION]
> В папке `Test` скопирован `LongIntegerString.dcu` из папки `Unit` — это и есть наша библиотечка или модуль с методами. При переносе консольного приложения
> нужно проверять, что `LongIntegerString.dcu` находиться в тойже папке, только в этом случае мы можем использовать этот модуль.

> [!TIP]
> Чтобы не перемещать эту библиотеку, чтобы она была встроенна в делфи ее(`LongIntegerString.dcu`) требуется переместить
> в `C:\Program Files (x86)\Borland\Delphi7\Lib`, после этого библиотека будет доступно из любого места при использовании `Delphi7`

# Структура данных
## Устройство самого модуля:  
- `TLongIntegerString`: Определяет тип string, который будет использоваться для представления длинного целого числа.

## Процедуры и функции:
- `InitLongIntegerString(Value: string): TLongIntegerString`: Инициализирует TLongIntegerString из строки.  
- `LongIntegerAddDigit(var Num: TLongIntegerString; Digit: Char)`: Добавляет цифру к концу строки, представляющей длинное целое число.  
- `IsDigitsOnly(Num: TLongIntegerString): Boolean`: Проверяет, состоят ли все символы в строке из цифр.  
- `LongIntegerAdd(Num1, Num2: TLongIntegerString): TLongIntegerString`: Складывает два длинных целых числа, представленных как строки, попозиционно.  
- `LongIntegerSubtract(Num1, Num2: TLongIntegerString): TLongIntegerString`: Вычитает два длинных целых числа, представленных как строки, попозиционно.
- `LongIntegerMultiply(Num1, Num2: TLongIntegerString): TLongIntegerString`: Умножает два длинных целых числа, представленных как строки, попозиционно.
- `LongIntegerDivide(Num1, Num2: TLongIntegerString): TLongIntegerString`: Делит два длинных целых числа, представленных как строки, нацело, попозиционно.
- `LongIntegerMod(Num1, Num2: TLongIntegerString): TLongIntegerString`: Возвращает остаток от деления нацело двух длинных целых чисел, представленных как строки, попозиционно.

# Условие:
> [!WARNING]
> Весь прикол лабы заключается только в одном:  
> `string`: ограничен на практике доступной памятью, в Delphi7 ограничен 2 ГБ. (`2 000 000 000 символов`)  
> `integer`: ограничен 4-мя байтами (32-битное представление). Диапазон значений от -2147483648 до 2147483647. (`10 символов`)  

Так что главная задача в этой лабораторной это создать тип данных, который сможет обрабатывать числа длинной более **10 символов**
