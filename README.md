# AXI4-Stream BCD Div4 Filter

Тестовое задание на летнюю стажировку в **Импульс**.

Проект реализует фильтр AXI4-Stream потока на **SystemVerilog**.  
Модуль принимает 8-битные значения в формате **BCD** и пропускает на выход только те значения, которые делятся на 4 без остатка.

---

## Текст задания

Разработать синтезируемый модуль на Verilog.  
Допускается Verilog-95, Verilog-2001, Verilog-2005, SystemVerilog.

Модуль должен реализовывать фильтр входного потока данных с интерфейсом **AXI4-Stream**.

В качестве ответа требуется ссылка на репозиторий GitFlic.

### Требования к интерфейсу

Использовать сигналы:

```text
s_axis_tvalid
s_axis_tready
s_axis_tdata[7:0]

m_axis_tvalid
m_axis_tready
m_axis_tdata[7:0]
```

Тактирование:

```text
clk
```

Сброс:

```text
rst
```

Сброс должен быть синхронным.

### Формат данных

Входные данные представлены в формате **BCD** — Binary-Coded Decimal:

```text
tdata[7:4] — десятки 0–9
tdata[3:0] — единицы 0–9
```

Допустимый диапазон значений:

```text
0–99
```

### Функциональность

Модуль должен:

- пропускать только те входные слова, для которых десятичное значение делится на 4 без остатка;
- остальные слова отбрасывать, то есть они не должны появляться на выходе;
- сохранять порядок пропущенных слов.

### Требования к протоколу

Модуль обязан:

- корректно обрабатывать backpressure через `m_axis_tready`;
- не терять данные, удовлетворяющие условию фильтрации;
- управлять сигналом `s_axis_tready`, то есть `s_axis_tready` не должен быть константой `1`;
- передавать выходные данные с корректным соблюдением AXI4-Stream handshake.

### Задание повышенной сложности

Дополнительно требуется:

- обработать случай некорректного BCD, когда любая цифра больше `9`;
- добавить параметризацию, например включение или выключение проверки BCD;
- разработать testbench, проверяющий корректность работы модуля.

Testbench должен генерировать входной поток с:

- случайными BCD-значениями;
- случайными невалидными BCD-значениями.

Также testbench должен выполнять случайное управление `m_axis_tready`.

Проверка должна подтверждать, что:

- на выходе появляются только числа, кратные `4`;
- порядок данных сохраняется;
- отсутствуют потери валидных данных.

---

## Используемые инструменты

- Язык: **SystemVerilog**
- Среда разработки: **Xilinx Vivado 2019.2**
- Целевая ПЛИС: **x7a100tcsg324-1**

---

## Структура проекта

```text
Тестовое задание Embedded FPGA /
├── rtl/
│   └── axi_bcd_filter.sv
├── tb/
│   └── axi_bcd_filter_tb.sv
├── screenshots/
│   ├── structure.png
│   ├── axi_bcd_filter.png
│   ├── waveform.png
│   └── syn.png
└── README.md
```

---

## Структурная схема

Модуль `axi_bcd_filter` расположен между AXI4-Stream master и AXI4-Stream slave.

```text
Master -> axi_bcd_filter -> Slave
```

Master генерирует входной поток данных.  
Фильтр принимает данные через `s_axis_*`, обрабатывает их и передаёт подходящие значения дальше через `m_axis_*`.  
Slave принимает отфильтрованный поток и управляет сигналом `m_axis_tready`.

![Structure](screenshots/structure.png)

---

## Описание задания

Необходимо реализовать модуль, который работает как фильтр AXI4-Stream потока.

На вход поступают 8-битные значения в формате BCD:

```text
s_axis_tdata[7:4] — десятки
s_axis_tdata[3:0] — единицы
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

---

## Проверка делимости на 4

BCD-число переводится в обычное десятичное значение:

```systemverilog
value = tens * 10 + ones;
```

После этого проверяется остаток от деления на 4:

```systemverilog
value % 4 == 0
```

В коде условие фильтрации реализовано через сигнал `pass_filter`.

---

## Параметр проверки BCD

В модуле есть параметр:

```systemverilog
parameter bit bsd_check = 1
```

Если `bsd_check = 1`, модуль проверяет корректность BCD-значения.  
Если `bsd_check = 0`, проверка BCD отключается.

Некорректные BCD-значения отбрасываются при включённом параметре `bsd_check`.

---

## Интерфейс модуля

```systemverilog
module axi_bcd_filter #(
    parameter bit bsd_check = 1
)(
    input  logic       clk,
    input  logic       rst,

    input  logic       s_axis_tvalid,
    input  logic [7:0] s_axis_tdata,
    output logic       s_axis_tready,

    output logic       m_axis_tvalid,
    output logic [7:0] m_axis_tdata,
    input  logic       m_axis_tready
);
```

---

## Основная логика модуля

Внутри модуля выделяются десятки и единицы:

```systemverilog
assign tens = s_axis_tdata[7:4];
assign ones = s_axis_tdata[3:0];
```

Условие прохождения фильтра:

```systemverilog
assign pass_filter = ((!bsd_check) || ((tens < 4'b1010) && (ones <  4'b1010))) && (((tens * 4'b1010 + ones) % 4) == 0);
```

Условия handshake:

```systemverilog
assign s_handshake = s_axis_tvalid && s_axis_tready;
assign m_handshake = m_axis_tvalid && m_axis_tready;
```

Формирование готовности входного интерфейса:

```systemverilog
assign s_axis_tready = m_axis_tready || !m_axis_tvalid;
```

---

## RTL-код в Vivado

Скриншот модуля `axi_bcd_filter` в Vivado:

![RTL Code](screenshots/axi_bcd_filter.png)

---

## Testbench

Для проверки был написан testbench `axi_bcd_filter_tb.sv`.

Testbench:

- генерирует случайные входные значения;
- подаёт как корректные BCD-значения, так и значения с цифрами `A..F`;
- выводит входные и выходные данные в консоль симуляции;

---

## Результаты симуляции

Waveform:

![Waveform](screenshots/waveform.png)

---

## Синтез в Vivado

Проект был успешно синтезирован в **Xilinx Vivado 2019.2**.

Скриншот успешного синтеза:

![Synthesis](screenshots/syn.png)

---

## Как запустить проект

1. Открыть проект в **Vivado**.
2. Добавить RTL-файл:

```text
rtl/axi_bcd_filter.sv
```

3. Добавить testbench:

```text
tb/axi_bcd_filter_tb.sv
```

4. Запустить симуляцию:

```text
Run Simulation
```

5. Проверить waveform.
6. Запустить синтез:

```text
Run Synthesis
```

7. Убедиться, что синтез завершился успешно.

---

## Автор

Тестовое задание выполнил: **Arsen Petrov**
