\# AXI4-Stream BCD Div4 Filter



Тестовое задание на летнюю стажировку в \*\*Импульс\*\*.



Проект реализует фильтр AXI4-Stream потока на \*\*SystemVerilog\*\*.  

Модуль принимает 8-битные значения в формате \*\*BCD\*\* и пропускает на выход только те значения, которые делятся на 4 без остатка.



\---



\## Используемые инструменты



\- Язык: \*\*SystemVerilog\*\*

\- Среда разработки: \*\*Xilinx Vivado 2019.2\*\*

\- Целевая ПЛИС: \*\*x7a100tcsg324-1\*\*



\---



\## Структура проекта



```text

axi\_bcd\_filter/

├── rtl/

│   └── axi\_bcd\_filter.sv

├── tb/

│   └── axi\_bcd\_filter\_tb.sv

├── screenshots/

│   ├── structure.png

│   ├── axi\_bcd\_filter.png

│   ├── waveform.png

│   └── syn.png

├── README.md

└── .gitignore

```



\---



\## Структурная схема



Модуль `axi\_bcd\_filter` расположен между AXI4-Stream master и AXI4-Stream slave.



```text

Master -> axi\_bcd\_filter -> Slave

```



Master генерирует входной поток данных.  

Фильтр принимает данные через `s\_axis\_\*`, обрабатывает их и передаёт подходящие значения дальше через `m\_axis\_\*`.  

Slave принимает отфильтрованный поток и управляет сигналом `m\_axis\_tready`.



!\[Structure](screenshots/structure.png)



\---



\## Описание задания



Необходимо реализовать модуль, который работает как фильтр AXI4-Stream потока.



На вход поступают 8-битные значения в формате BCD:



```text

s\_axis\_tdata\[7:4] — десятки

s\_axis\_tdata\[3:0] — единицы

```



Примеры корректных BCD-значений:



```text

8'h00 = 0

8'h04 = 4

8'h12 = 12

8'h24 = 24

8'h99 = 99

```



Примеры некорректных BCD-значений:



```text

8'h1A

8'hA0

8'h2F

8'hFF

```



Так как в BCD каждая цифра должна быть от `0` до `9`, значения `A..F` считаются некорректными.



\---



\## Принцип работы



Модуль принимает входные данные через интерфейс:



```text

s\_axis\_tvalid

s\_axis\_tready

s\_axis\_tdata

```



И выдаёт отфильтрованные данные через интерфейс:



```text

m\_axis\_tvalid

m\_axis\_tready

m\_axis\_tdata

```



Передача данных происходит только при выполнении условия AXI4-Stream handshake:



```systemverilog

tvalid \&\& tready

```



Если число корректное и делится на 4, оно передаётся на выход.  

Если число не делится на 4 или является некорректным BCD, оно отбрасывается.



Пример:



```text

Вход:  00, 01, 02, 03, 04, 05, 08, 12, 1A, FF, 16

Выход: 00, 04, 08, 12, 16

```



\---



\## Проверка делимости на 4



BCD-число переводится в обычное десятичное значение:



```systemverilog

value = tens \* 10 + ones;

```



После этого проверяется остаток от деления на 4:



```systemverilog

value % 4 == 0

```



В коде условие фильтрации реализовано через сигнал `pass\_filter`.



\---



\## Поддержка backpressure



Модуль поддерживает ситуацию, когда выходной приёмник временно не готов принимать данные.



Если:



```systemverilog

m\_axis\_tvalid = 1

m\_axis\_tready = 0

```



то выходные данные удерживаются на `m\_axis\_tdata`, пока не произойдёт успешная передача:



```systemverilog

m\_axis\_tvalid \&\& m\_axis\_tready

```



Сигнал `s\_axis\_tready` не является константой. Он зависит от состояния выходного интерфейса:



```systemverilog

s\_axis\_tready = m\_axis\_tready || !m\_axis\_tvalid;

```



Это позволяет останавливать входной поток, если внутри модуля уже есть данные, ожидающие передачи на выход.



\---



\## Параметр проверки BCD



В модуле есть параметр:



```systemverilog

parameter bit bsd\_check = 1

```



Если `bsd\_check = 1`, модуль проверяет корректность BCD-значения.  

Если `bsd\_check = 0`, проверка BCD отключается.



Некорректные BCD-значения отбрасываются при включённом параметре `bsd\_check`.



\---



\## Интерфейс модуля



```systemverilog

module axi\_bcd\_filter #(

&#x20;   parameter bit bsd\_check = 1

)(

&#x20;   input  logic       clk,

&#x20;   input  logic       rst,



&#x20;   input  logic       s\_axis\_tvalid,

&#x20;   input  logic \[7:0] s\_axis\_tdata,

&#x20;   output logic       s\_axis\_tready,



&#x20;   output logic       m\_axis\_tvalid,

&#x20;   output logic \[7:0] m\_axis\_tdata,

&#x20;   input  logic       m\_axis\_tready

);

```





\## Основная логика модуля



Внутри модуля выделяются десятки и единицы:



```systemverilog

assign tens = s\_axis\_tdata\[7:4];

assign ones = s\_axis\_tdata\[3:0];

```



Условие прохождения фильтра:



```systemverilog

assign pass\_filter = ((!bsd\_check) || ((tens < 4'b1010) \&\& (ones <  4'b1010))) \&\& (((tens \* 4'b1010 + ones) % 4) == 0);

```



Условия handshake:



```systemverilog

assign s\_handshake = s\_axis\_tvalid \&\& s\_axis\_tready;

assign m\_handshake = m\_axis\_tvalid \&\& m\_axis\_tready;

```



Формирование готовности входного интерфейса:



```systemverilog

assign s\_axis\_tready = m\_axis\_tready || !m\_axis\_tvalid;

```



\---



\## RTL-код в Vivado



Скриншот модуля `axi\_bcd\_filter` в Vivado:



!\[RTL Code](screenshots/axi\_bcd\_filter.png)



\---



\## Testbench



Для проверки был написан testbench `axi\_bcd\_filter\_tb.sv`.



Testbench:



\- генерирует случайные входные значения;

\- подаёт как корректные BCD-значения, так и значения с цифрами `A..F`;

\- выводит входные и выходные данные в консоль симуляции;

\- проверяет работу при изменении `m\_axis\_tready`.



\---



\## Результаты симуляции



Скриншот временной диаграммы:



!\[Waveform](screenshots/waveform.png)



\---



\## Синтез в Vivado



Проект был успешно синтезирован в \*\*Xilinx Vivado\*\*.



Выбранная целевая ПЛИС:



```text

x7a100tcsg324-1

```



Скриншот успешного синтеза:



!\[Synthesis](screenshots/syn.png)



\---



\## Как запустить проект



1\. Открыть проект в \*\*Vivado\*\*.

2\. Добавить RTL-файл:



```text

rtl/axi\_bcd\_filter.sv

```



3\. Добавить testbench:



```text

tb/axi\_bcd\_filter\_tb.sv

```



4\. Запустить симуляцию:



```text

Run Simulation

```



5\. Проверить waveform.

6\. Запустить синтез:



```text

Run Synthesis

```



7\. Убедиться, что синтез завершился успешно.



\---



\## Автор



Тестовое задание выполнил: \*\*Arsen Petrov\*\*



