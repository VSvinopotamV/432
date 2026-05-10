# AXI4-Stream BCD Div4 Filter

Тестовое задание на летнюю стажировку в **Импульс от Ядра**.

Проект реализует фильтр AXI4-Stream потока на SystemVerilog.  
Модуль принимает 8-битные значения в формате BCD и пропускает на выход только те значения, которые делятся на 4 без остатка.

---

## Используемые инструменты

- Язык: **SystemVerilog**
- Среда разработки: **Xilinx Vivado**
- Целевая ПЛИС: **x7a100tcsg324-1**
- Интерфейс: **AXI4-Stream**

---

## Структура проекта

```text
axi_bcd_filter/
├── rtl/
│   └── axi_bcd_filter.sv
├── tb/
│   └── tb_axi_bcd_filter.sv
├── screenshots/
│   ├── simulation.png
│   ├── waveform.png
│   └── synthesis.png
├── README.md
└── .gitignore
```

---

## Описание задания

Необходимо реализовать модуль, который работает как фильтр AXI4-Stream потока.
![Structure](structure.png)
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

## Принцип работы

Модуль принимает входные данные через интерфейс:

```text
s_axis_tvalid
s_axis_tready
s_axis_tdata
```

И выдаёт отфильтрованные данные через интерфейс:

```text
m_axis_tvalid
m_axis_tready
m_axis_tdata
```

Передача данных происходит только при выполнении условия AXI4-Stream handshake:

```systemverilog
tvalid && tready
```

Если число корректное и делится на 4, оно передаётся на выход.  
Если число не делится на 4 или является некорректным BCD, оно отбрасывается.

Пример:

```text
Вход:  00, 01, 02, 03, 04, 05, 08, 12, 1A, FF, 16
Выход: 00, 04, 08, 12, 16
```

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

---

## Поддержка backpressure

Модуль поддерживает ситуацию, когда выходной приёмник временно не готов принимать данные.

Если:

```systemverilog
m_axis_tvalid = 1
m_axis_tready = 0
```

то выходные данные удерживаются на `m_axis_tdata`, пока не произойдёт успешная передача:

```systemverilog
m_axis_tvalid && m_axis_tready
```

Сигнал `s_axis_tready` не является константой. Он зависит от состояния выходного интерфейса:

```systemverilog
s_axis_tready = m_axis_tready || !m_axis_tvalid;
```

Это позволяет останавливать входной поток, если внутри модуля уже есть данные, ожидающие передачи на выход.

---

## Параметр проверки BCD

В модуле есть параметр:

```systemverilog
parameter bit bsd_check = 1
```

Если `bsd_check = 1`, модуль проверяет корректность BCD-значения.  
Если `bsd_check = 0`, проверка BCD отключается.

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

## Сигналы

| Сигнал | Направление | Описание |
|---|---|---|
| `clk` | input | Тактовый сигнал |
| `rst` | input | Синхронный сброс |
| `s_axis_tvalid` | input | Валидность входных данных |
| `s_axis_tdata` | input | Входное BCD-значение |
| `s_axis_tready` | output | Готовность модуля принять входные данные |
| `m_axis_tvalid` | output | Валидность выходных данных |
| `m_axis_tdata` | output | Выходное BCD-значение |
| `m_axis_tready` | input | Готовность приёмника принять выходные данные |

---

## Testbench

Для проверки был написан простой testbench `tb_axi_bcd_filter.sv`.

Testbench:

- генерирует случайные входные значения;
- подаёт как корректные BCD-значения, так и значения с цифрами `A..F`;
- выводит входные и выходные данные в консоль симуляции;
- проверяет работу при периодическом изменении `m_axis_tready`.

---

## Результаты симуляции

### Консоль симуляции

Скриншот вывода консоли Vivado/XSim:

![Simulation Console](screenshots/simulation.png)

---

### Waveform

Скриншот временной диаграммы, где видно:

- входные данные `s_axis_tdata`;
- сигнал `s_axis_tvalid`;
- сигнал `s_axis_tready`;
- выходные данные `m_axis_tdata`;
- сигнал `m_axis_tvalid`;
- сигнал `m_axis_tready`;
- удержание данных при `m_axis_tready = 0`.

![Waveform](screenshots/waveform.png)

---

## Синтез в Vivado

Проект был создан и проверен в **Xilinx Vivado**.

Выбранная целевая ПЛИС:

```text
x7a100tcsg324-1
```

Скриншот успешного синтеза:

![Synthesis](screenshots/synthesis.png)

---

## Основные особенности реализации

- Используется синхронный сброс.
- Выходные данные хранятся в регистрах.
- Поддерживается AXI4-Stream handshake.
- Поддерживается backpressure.
- `s_axis_tready` формируется не как константа, а зависит от готовности выходного интерфейса.
- Некорректные BCD-значения отбрасываются при включённом параметре `bsd_check`.

---

## Как запустить

1. Открыть проект в Vivado.
2. Добавить файл модуля:

```text
rtl/axi_bcd_filter.sv
```

3. Добавить testbench:

```text
tb/tb_axi_bcd_filter.sv
```

4. Запустить **Run Simulation**.
5. Проверить вывод в консоли и waveform.
6. При необходимости запустить **Run Synthesis** для выбранной ПЛИС `x7a100tcsg324-1`.

---

## Автор

Тестовое задание выполнил: **Arsen Petrov**
