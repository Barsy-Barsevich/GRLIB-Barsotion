
; Будем пытаться написать Новую Библиотеку ;)


;Задержки
; Функция MacroDelay - программная задержка
; Функция Delay - программная задержка

;Операции ввода-вывода
; Функция lcdCommOut - отправка команды на lcd-дисплей
; Функция lcdDataOut - отправка байта данных на lcd-дисплей
; Функция ST7920_INI - инициализация дисплея на ST7920 в граф. режиме
; Функция GR_MAS - перенос массива 1кБ в видеопамять дисплея
; Функция PRINT_BUF - перенос содержимого буфера в видеопамять дисплея
; Функция BUF_CLR - очистка буфера

;Операции преобразований
; Функция BN2HEX - преобразование двоичных данных в шестнадцитиричные
;  в коде ASCII
; Функция HEX2BN - преобразование шестнадцатиричных данных в коде ASCII
;  в двоичные

;Арифметические операции
; Функция SUB16 - 16р вычитание
; Функция MUL16 - умножение 16р чисел
; Функция SDVI16 - 16р деление со знаком
; Функция UDVI16 - 16р деление без знака
; Функция CMP16 - 16р сравнение
; Функция ABS - модуль 16р числа

;Операции над строками
; Функция STRCMP - сравнение строк
; Функция CONCAT - объединение строк
; Функция POS - позиция подстроки в строке

;Поразрядные операции
; Функция BITSET - установка разряда
; Функция BITCLR - очистка разряда
; Функция BITTST - проверка разряда

; Функция MFILL - заполнение памяти



.include AFS2.def

;
; Функция MacroDelay - программная задержка
;
; Используется для организации программных задержек.
; Время задержки рассчитывается по формуле:
; t = (20*A+25)/fтакт мкс
;
; Ввод: А
; Вывод: нет
;
; Используемые регистры: АF
; Используемая память: нет
;
; Длина: 5 байт
; Время выполнения: 20*A+25 тактов
;
; Начало кода:

MacroDelay:
; в А - операнд
sui 01H
jnz MacroDelay
ret



;
; Функция Delay - программная задержка
;
; Используется для организации программных задержек.
; Время задержки рассчитывается по формуле:
; t = (6000*HL+25)/fтакт мкс
; t = HL миллисекунд при fтакт = 6.0 МГц
;
; Ввод: HL
; Вывод: нет
;
; Используемые регистры: АF,HL
; Используемая память: нет
;
; Длина: 20 байт
; Время выполнения: (25*238+47)*HL+7 тактов
;
; Начало кода:

Delay:
mvi a,EEH
delay_1:
dcr a
nop
nop
jnz delay_1

mov a,l
sui 01H
mov l,a
mov a,h
sbi 00H
mov h,a
jnc Delay
ret



;
; Функция lcdCommOut - отправка команды на lcd-дисплей
; Используется для организации общения с lcd дисплеями по 8-бит параллельной шине.
;
; Выводы портов:
;
; Порт 00Н (тип 'A' ИС 8255), инициализирован на вывод.
; Это шина данных к дисплею.
;
; Порт 02Н (тип 'B' ИС 8255), инициализирован на вывод.
; B(0) -- Enable
; B(1) -- R/W
; B(2) -- Data/Comm
; остальные линии порта не изменяются.
;
; Ввод: A
; Вывод: нет
;
; Используемые регистры: А,C,F
; Используемая память: нет
; Используемые функции:
;  - MacroDelay
;
; Длина: 26 байт
; Время выполнения: 173 такта
;
; Начало кода:

lcdCommOut:
mov c,a
in port_display_B
ani F8H
out port_display_B
mov a,c
out port_display_A
in port_display_B
inr a
out port_display_B
mvi a,01H
call MacroDelay
in port_display_B
dcr a
out port_display_B
ret



;
; Функция lcdDataOut - отправка байта данных на lcd-дисплей
; Используется для организации общения с lcd дисплеями по 8-бит параллельной шине.
;
; Выводы портов:
;
; Порт 00Н (тип 'A' ИС 8255), инициализирован на вывод.
; Это шина данных к дисплею.
;
; Порт 02Н (тип 'B' ИС 8255), инициализирован на вывод.
; B(0) -- Enable
; B(1) -- R/W
; B(2) -- Data/Comm
; остальные линии порта не изменяются.
;
; Ввод: A
; Вывод: нет
;
; Используемые регистры: АF,C
; Используемая память: нет
; Используемые функции:
;  - MacroDelay
;
; Длина: 29 байт
; Время выполнения: 183 такта
;
; Начало кода:

lcdDataOut:
mov c,a
in port_display_B
ani F8H
adi 04H
out port_display_B
mov a,c
out port_display_A
in port_display_B
inr a
out port_display_B
mvi a,01H
call MacroDelay
in port_display_B
ani F8H
out port_display_B
ret



;
; Функция ST7920_INI - инициализация дисплея на ST7920 в граф. режиме
;
; Ввод: нет
; Вывод: нет
;
; Используемые регистры: АF,C
; Используемая память: нет
; Используемые функции:
;  - lcdCommOut
;  - lcdDataOut
;  - MacroDelay
;
; Длина: 29 байт
; Время выполнения: 183 такта
;
; Начало кода:

ST7920_INI:
mvi a,30H
call lcdCommOut
mvi a,0CH
call lcdCommOut
mvi a,30H
call lcdCommOut
mvi a,01H
call lcdCommOut
mvi a,FFH
call MacroDelay
mvi a,FFH
call MacroDelay
mvi a,34H
call lcdCommOut
mvi a,02H
call lcdCommOut
mvi a,36H
call lcdCommOut
ret



;
; Функция GR_MAS - перенос массива 1кБ в видеопамять дисплея
;
; Ввод: HL - начальный ардес массива в памяти
; Вывод: нет
;
; Используемые регистры: АF,C,DE,HL
; Читаемая память:
; Используемая память:
;  - disp_addr_x (byte)
;  - disp_addr_y (byte)
; Используемые функции:
;  - lcdCommOut
;  - lcdDataOut
;  - MacroDelay
;
; Примечание:
; Функция древняя, очень замудрена, написана еще тогда, когда
; я считал нормой писать на ассемблере без комментариев.
; Благо, работает. Не трогать!
;
; Длина: 
; Время выполнения: 
;
; Начало кода:

GR_MAS:
mvi a,80H
sta disp_addr_y
sta disp_addr_x
mov e,a
gr_mas_2:
lda disp_addr_y
call lcdCommOut
lda disp_addr_x
call lcdCommOut
mvi d,00H
gr_mas_1:
mov a,m
call lcdDataOut
inx h
inr d
mov a,d
cpi 10H
jnz gr_mas_1
lda disp_addr_y
inr a
sta disp_addr_y
cpi A0H
jnz gr_mas_2
mov a,e
inr a
cpi 82H
rz
mov e,a
lda disp_addr_y
sui 20H
sta disp_addr_y
lda disp_addr_x
adi 08H
sta disp_addr_x
jmp gr_mas_2



;
; Функция PRINT_BUF - перенос содержимого буфера в видеопамять дисплея
;
; Ввод: start_buf_addr (word) - адрес начала буфера в памяти
; Вывод: нет
;
; Используемые регистры: АF,C,DE,HL
; Читаемая память:
;  - start_buf_addr (word)
; Используемая память: нет
; Используемые функции:
;  - lcdCommOut
;  - lcdDataOut
;  - MacroDelay
;  - GR_MAS
;
; Длина: 
; Время выполнения: 
;
; Начало кода:

;  - start_buf_addr (word)
PRINT_BUF:
lhld start_buf_addr
call GR_MAS
ret



;
; Функция BUF_CLR - очистка буфера
;
; Ввод:  Адрес начала буфера в памяти -- start_buf_addr
; Вывод: нет
;
; Используемые регистры: AF,С,DE,HL
; Читаемая память:
;  - start_buf_addr
; Используемая память: нет
; Используемые функции:
;  - MFILL
;
; Длина: 12 байт
; Время выполнения: 37960 тактов
;
; Начало кода:

BUF_CLR:
lxi d,0400H
lhld start_buf_addr
mvi a,00H
call MFILL
ret



;
; Функция BN2HEX - преобразование двоичных данных в шестнадцитиричные
; в коде ASCII
;
; Ввод: A
; Вывод: H - ст цифра, L - мл цифра
;
; Используемые регистры: АF,B,HL
; Используемая память: нет
;
; Длина: 29 байт
; Время выполнения: ~160 + 4 для каждой недесятичной цифры тактов
;
; Начало кода:

BN2HEX:
; Преобразовать старшую половину в код ASCII
mov b,a        ;сохранить начальное значение
ani $F0        ;взять ст половину
rrc            ;переслать ст половину в мл
rrc
rrc
rrc
call bn2hex_nascii   ;преобразовать ст половину в код ASCII

mov h,a        ;возвратить в H

; Преобразовать младшую половину в код ASCII
mov a,b
ani $F0
call bn2hex_nascii
mov l,a        ;возвратить мл половину в H
ret

; Подпрограмма nascii преобразует шестнадцатиричную цифру в символ
; в коде ASCII.
; Вход:  А - двоичное число в мл половине байта
; Выход: А - символ в коде ASCII
; Используемые регистры - AF

bn2hex_nascii:
cpi $0A
jc bn2hex_nas1
adi $07
bn2hex_nas1:
adi $30
ret



;
; Функция HEX2BN - преобразование шестнадцатиричных данных в коде ASCII
; в двоичные
;
; Ввод: H - ст цифра, L - мл цифра
; Вывод: A
;
; Используемые регистры: АF,B
; Используемая память: нет
;
; Длина: 25 байт
; Время выполнения: 126 + 10 для каждой недесятичной цифры тактов
;
; Начало кода:

HEX2BN:
mov a,l            ;взять мл символ
call hex2bn_a2hex  ;преобразовать в шест цифру
mov b,a            ;сохранить шест значение в В
mov a,h            ;взять ст символ
call hex2bn_a2hex  ;преобразовать в шест цифру
rlc                ;сдвинуть на 4 разряда
rlc
rlc
rlc
ora b              ;"ИЛИ" с мл
ret

; Подпрограмма a2hex
; Превращает цифру в коде ASCII в шестнадцатиричную
; Вход А
; Выход А

hex2bn_a2hex:
sui $30
cpi $0A
rc
sui $07
ret



;
; Функция SUB16 - 16р вычитание
;
; Ввод: HL (уменьшаемое)
;       DE (вычитаемое)
; Вывод: HL
;
; Используемые регистры: AF,HL
; Используемая память: нет
;
; Длина: 7 байт
; Время выполнения: 52 такта
;
; Начало кода:

SUB16:
mov a,l
sub e
mov l,a
mov a,h
sbb d
mov h,a
ret



;
; Функция MUL16 - умножение 16р чисел
;
; Ввод: HL (множимое)
;       DE (множитель)
; Вывод: HL (младшее слово произведения)
;
; Используемые регистры: все
; Используемая память: нет
;
; Длина: 26 байт
; Время выполнения: 1001..1065 тактов
;
; Начало кода:

MUL16:
mov c,l
mov b,h
lxi h,0000H
mvi a,0FH

mul16_1:
push psw
ora d
jp mul16_2
dad b

mul16_2:
dad h
xchg
dad h
xchg
pop psw
dcr a
jnz mul16_1

ora d
rp
dad b
ret



;
; Функция SDVI16 - 16р деление со знаком
; Функция UDVI16 - 16р деление без знака
;
; Ввод:  HL (делимое)
;        DE (делитель)
; Вывод: HL (частное)
;        DE (остаток)
; Если делитель равен 0, программа возвращает флаг C=1, частное и остаток при этом равны 0000H.
;
; Используемые регистры: все
; Используемая память: 3 ячейки в любой обл ОЗУ
;  - div16_srem (byte)
;  - div16_squot (byte)
;  - div16_count (byte)
;
; Длина: 136 байт
; Время выполнения: 2480..2950 тактов
;
; Начало кода:

; деление со знаком
SDIV16:
; определить знак частного с помощью xor
; остаток имеет тот же знак, что и делимое
mov a,h
sta div16_srem
xra d
sta div16_squot

; получить абсолютное значение делителя
mov a,d
ora a
jp div16_chkde
sub a
sub e
mov e,a
sbb a
sub d
mov d,a

; получить абсолютное значение делителя
div16_chkde:
mov a,h
ora a
jp div16_dodiv
sub a
sub l
mov l,a
sbb a
sub h
mov h,a

; разделить абсолютные значения
div16_dodiv:
call UDIV16
; при делении на 0 выйти из подпрограммы
rc

; сделать частное отрицательным, если оно должно быть таковым
lda div16_squot
ora a
jp div16_dorem
mvi a,00H
sub l
mov l,a
mvi a,00H
sbb h
mov h,a

; сделать остаток отрицательным, если он должен быть таковым
div16_dorem:
lda div16_srem
ora a
rp
sub a
sub e
mov e,a
sbb a
sub d
mov d,a
ret

; деление без знака
UDIV16:
; проверить деление на 0
mov a,e
ora d
jnz div16_divide
lxi h,0000H
mov d,h
mov e,l
stc
ret

div16_divide:
mov c,l
mov b,h
lxi h,0000H
mvi a,10H
ora a

div16_dvloop:
sta div16_count

; сдвинуть сл разряд частного в разряд 0 делимого
; сдвинуть сл ст разряд делимого в мл разряд остатка
; BC содержит как делимое, так и частное.
; сдвигая разряд из ст байта делимого, мы сдвигаем в регистр из флага переноса сл разряд частного

; HL содержит остаток

mov a,c
ral
mov c,a
mov a,b
ral
mov b,a
mov a,l
ral
mov l,a
mov a,h
ral
mov h,a

push h
mov a,l
sub e
mov l,a
mov a,h
sbb d
mov h,a
cmc
jc div16_drop
xthl

div16_drop:
inx sp
inx sp
lda div16_count
dcr a
jnz div16_dvloop

; сдвинуть посл перенос в частное
xchg
mov a,c
ral
mov l,a
mov a,b
ral
mov h,a
ora a
ret



;
; Функция CMP16 - 16р сравнение
;
; Ввод: HL (уменьшаемое)
;       DE (вычитаемое)
; Вывод: Z=1 - HL=DE
;        Z=0 - HL!=DE
;        С=1 - HL<DE   для чисел без знаков
;        C=0 - HL>=DE
;        S=1 - HL<DE   для чисел со знаками
;        S=0 - HL>=DE
;
; Используемые регистры: AF
; Используемая память: нет
;
; Длина: 36 байт
; Время выполнения: 51..69 тактов
;
; Начало кода:

CMP16:
mov a,d
xra h
jm cmp16_diff
; переполнение невозмжно - выполнить сравнение без знака
mov a,l
sub e
jz cmp16_equal

; мл байты не равны, сравнить старшие биты
; запомним, что флаг С позднее должен быть очищен
mov a,h
sbb d
jc cmp16_cyset
jnc cmp16_cyclr

; мл байты равны
cmp16_equal:
mov a,h
sbb d
ret

cmp16_diff:
mov a,l
sub e
mov a,h
sbb d
mov a,h
jnc cmp16_cyclr

cmp16_cyset:
ori 01H
stc
ret

cmp16_cyclr:
ori 01H
ret



;
; Функция ABS - модуль 16р числа
;
; Ввод: HL (int)
; Вывод: HL (int)
;
; Используемые регистры: AF,HL
; Используемая память: нет
;
; Длина: 13 байт
; Время выполнения: 14/84 такта
;
; Начало кода:

ABS:
mov a,h
ora a
rp
push d
xchg
lxi h,$0000
call SUB16
pop d
ret



;
; Функция STRCMP - сравнение строк
;
; Ввод: HL (базовый адрес str1)
;       DE (базовый адрес str2)
; Вывод: Z=1 - str1=str2
;        Z=0 - str1!=str2
;        C=1 - str1<str2
;        C=0 - str1>=str2
;
; Используемые регистры: AF,B,DE,HL
; Используемая память: 2 ячейки в любой обл ОЗУ
;  - strcmp_lens1 (byte)
;  - strcmp_lens2 (byte)
;
; Длина: 36 байт
; Время выполнения: 52*(ДЛИНА САМОЙ КОРОТКОЙ СТРОКИ)+113+18
;
; Начало кода:

STRCMP:
ldax d
sta strcmp_lens2
cmp m
jc strcmp_begcmp
mov a,m

strcmp_begcmp:
ora a
jz strcmp_cmplen
mov b,a
xchg
ldax d
sta strcmp_lens1

strcmp_cmplp:
inx d
inx h
ldax d
cmp m
rnz
dcr b
jnz strcmp_cmplp

strcmp_cmplen:
lda strcmp_lens1
lxi h,strcmp_lens2
cmp m
ret



;
; Функция CONCAT - объединение строк
; Строка 2 присоединяется к строке 1, при этом строка 1 соотв увеличивается.
; Если длина результ строки превышает максимальную, присоединяется только та часть строки 2, которая позволяет получитьь строку 1 максимальной длины.
; Ели какая-то часть строки 2 получается отброшена, устанавливается флаг С.
;
; Ввод: HL (базовый адрес str1)
;       DE (базовый адрес str2)
;       B (макс. длина строки 1)
; Вывод: измененная строка 1
;        С=1 - часть строки 2 была отброшена
;        С=0 - часть строки 2 не была отброшена
;
; Используемые регистры: все
; Используемая память: 5 байт в любой обл. ОЗУ
;  - concat_s1adr (word)
;  - concat_s1len (byte)
;  - concat_s2len (byte)
;  - concat_strgov (byte)
;
; Длина: 83 байта
; Время выполнения: 40*(ЧИСЛО ПРИСОЕДИНЯЕМЫХ СИМВОЛОВ)+265+18
;
; Начало кода:


CONCAT:
shld concat_s1adr
push b
mov a,m
sta concat_s1len
mov c,a
mvi b,00H
dad b
ldax d
sta concat_s2len
pop b
mov c,a
lda concat_s1len
add c
jc concat_toolng
cmp b
jz concat_lenok
jc concat_lenok

concat_toolng:
mvi a,FFH
sta concat_strgov
lda concat_s1len
mov c,a
mov a,b
sub c
rc
sta concat_s2len
mov a,b
sta concat_s1len
jmp concat_docat

concat_lenok:
sta concat_s1len
sub a
sta concat_strgov

concat_docat:
lda concat_s2len
ora a
jz concat_exit
mov b,a

concat_catlp:
inx h
inx d
ldax d
mov m,a
dcr b
jnz concat_catlp

concat_exit:
lda concat_s1len
lhld concat_s1adr
mov m,a
lda concat_strgov
rar
ret



;
; Функция POS - нахождение адреса подстроки в строке
;
; Ищет первое появление подстроки в строке и возвращает ее начальный индекс.
; Если подстрока не найдена, возвращает 0
;
; Ввод: HL (базовый адрес строки)
;       DE (базовый адрес подстроки)
; Вывод: A
;
; Используемые регистры: все
; Используемая память: 7 байт в любой обл. ОЗУ
;  - pos_string (word)
;  - pos_substg (word)
;  - pos_slen (byte)
;  - pos_sublen (byte)
;  - pos_index (byte)


POS:
shld pos_string
xchg
mov a,m
ora a
jz pos_notfnd
inx h
shld pos_substg
sta pos_sublen
mov c,a
ldax d
ora a
jz pos_notfnd

sub c
jc pos_notfnd
inr a
mov c,a
sub a
sta pos_index

pos_slp1:
lxi h,pos_index
inr m
lda pos_sublen
mov b,a
lhld pos_substg
xchg
lhld pos_string
inx h
shld pos_string

pos_cmplp:
ldax d
cmp m
jnz pos_slp2
dcr b
jz pos_found
inx h
inx d
jmp pos_cmplp

pos_slp2:
dcr c
jnz pos_slp1
jz pos_notfnd

pos_found:
lda pos_index
ret

pos_notfnd:
sub a
ret


;
; Функция BITSET - установка разряда
;
; Ввод: B (исходное число), A (номер разряда 2-1-0)
; Вывод: A (B с установленным разрядом)
;
; Используемые регистры: AF,BС,HL
; Используемая память: нет
;
; Длина: 20 байт
; Время выполнения: 59 тактов
;
; Начало кода:

BITSET:
    ani 07H
    mov c,a
    mov a,b
    lxi h,bitset_msk
    mvi b,00h
    dad b
    ora m
    ret
bitset_msk:
    .db 01h
    .db 02h
    .db 04h
    .db 08h
    .db 10h
    .db 20h
    .db 40h
    .db 80h
    
    
;
; Функция BITCLR - очистка разряда
;
; Ввод: B (исходное число), A (номер разряда 2-1-0)
; Вывод: A (B с отчищенным разрядом)
;
; Используемые регистры: AF,BС,HL
; Используемая память: нет
;
; Длина: 20 байт
; Время выполнения: 59 тактов
;
; Начало кода:

BITCLR:
    ani 07H
    mov c,a
    mov a,b
    lxi h,bitclr_msk
    mvi b,00h
    dad b
    ana m
    ret
bitclr_msk:
    .db FEh
    .db FDh
    .db FBh
    .db F7h
    .db EFh
    .db DFh
    .db BFh
    .db 7Fh
    
    
;
; Функция BITTST - проверка разряда
;
; Ввод: B (исходное число), A (номер разряда 2-1-0)
; Вывод: Z=1 - разряд очищен
;        Z=0 - разряд установлен
;
; Используемые регистры: AF,BС,HL
; Используемая память: нет
;
; Длина: 20 байт
; Время выполнения: 59 тактов
;
; Начало кода:

BITTST:
    ani 07H
    mov c,a
    mov a,b
    lxi h,bitset_msk
    mvi b,00h
    dad b
    ana m
    ret
    
    
    
;
; Функция MFILL - заполнение памяти
;
; Ввод:  Адрес начала - HL
;        Размер области - DE
;        Значение, помещаемое в память - A
; Вывод: нет
;
; Используемые регистры: AF,С,DE,HL
; Используемая память: нет
;
; Длина: 10 байт
; Время выполнения: DE*37+11
;
; Начало кода:

MFILL:
mov c,a
mfill-loop:
mov m,c
inx h
dcx d
mov a,e
ora d
jnz mfill-loop
ret

