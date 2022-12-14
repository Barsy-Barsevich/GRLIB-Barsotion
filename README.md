# GRLIB-Barsotion
Графическая библиотека для компьютеров на базе процессоров 8080 и 8085

Позволяет рисовать и стирать точки, линии, буквы, строки текста, окружности, скругленные прямоугольники на экране с горизонтальным разрешением до 2040 пикселей.
Подойдет практически к любой операционной системе.

- GRLIB.asm -- главный файл, в нем содержится ассемблерный код библиотеки.
- GRLIB.def -- файл, содержащий настроечные константы и адреса переменных, используемых библиотекой. Если вы хотите использовать библиотеку на своем железе, внимательно отнеситесь к установке адресов ячеек памяти. Обращайте внимание на тип переменных (byte,char - 1 байт, int,word - 2 байта)
- GRLIB.h -- заголовочный файл библиотеки, там содержатся ссылки на адреса запуска функций библиотеки. Ассемблируя библиотеку, перенесите сюда адреса запуска функций.
- GRLIB800.bin -- заассемблированный файл, адрес запуска -- 800H. Требует наличие библиотеки AFS2 по адресу 1500H.

Да, для работы GRLIB нужны функции из AFS2. AFS2 -- это прототип универсальной базовой библиотеки для моей операционной системы (находится в разработке сейчас). Функции этой библиотеки взяты в основном из книги "Программирование микропроцессоров 8080 и 8085 на языке ассемблера", авторы -- Левенталь и Сэйвилл.

- AFS2.asm -- код
- AFS2.def -- константы и переменные
- AFS2.h -- заголовочный файл
- AFS2_1500.bin -- заассемблированный файл, адрес запуска -- 1500H

Если вы собираетесь печатать текст или отдельные символы с помощью библиотеки, вам нужно будет подключить таблицу шрифтов. Библиотека позволяет печатать строки текста в стиле "моно", а также в "оптимизированном" стиле; для каждого стиля должна быть своя таблица шрифтов. На данный момент (27.11.22, 02:44 ночи) таблица для стиля моно не готова, но я ее обязательно сюда добавлю позже. Я использую разработанный мной же шрифт saluan.
Таблица шрифтов загружается в память начиная с определенного адреса, этот адрес вы должны указать при инициализации библиотеки. Прочтите файл Howto.
И, конечно, вы можете составить свой шрифт и таблицу шрифтов, чтобы рисовать любимые символы.
