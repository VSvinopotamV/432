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

На вход поступают 8-битные значения в формате BCD:

```text
s_axis_tdata[7:4] — десятки
s_axis_tdata[3:0] — единицы
```
%3CmxGraphModel%3E%3Croot%3E%3CmxCell%20id%3D%220%22%2F%3E%3CmxCell%20id%3D%221%22%20parent%3D%220%22%2F%3E%3CmxCell%20id%3D%222%22%20parent%3D%221%22%20style%3D%22rounded%3D0%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3B%22%20value%3D%22Master%22%20vertex%3D%221%22%3E%3CmxGeometry%20height%3D%22240%22%20width%3D%22120%22%20x%3D%22100%22%20y%3D%22320%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%223%22%20parent%3D%221%22%20style%3D%22rounded%3D0%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3B%22%20value%3D%22Slave%22%20vertex%3D%221%22%3E%3CmxGeometry%20height%3D%22240%22%20width%3D%22120%22%20x%3D%22600%22%20y%3D%22320%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%224%22%20parent%3D%221%22%20style%3D%22rounded%3D0%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3B%22%20value%3D%22axi_bcd_filter%22%20vertex%3D%221%22%3E%3CmxGeometry%20height%3D%22240%22%20width%3D%22120%22%20x%3D%22350%22%20y%3D%22320%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%225%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BexitX%3D1%3BexitY%3D0.25%3BexitDx%3D0%3BexitDy%3D0%3BentryX%3D0%3BentryY%3D0.25%3BentryDx%3D0%3BentryDy%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22220%22%20y%3D%22400%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22350%22%20y%3D%22400%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%226%22%20connectable%3D%220%22%20parent%3D%225%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22s_axis_tvalid%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.0308%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22-3%22%20y%3D%22-10%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%227%22%20edge%3D%221%22%20parent%3D%221%22%20source%3D%222%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BexitX%3D1%3BexitY%3D0.5%3BexitDx%3D0%3BexitDy%3D0%3BentryX%3D0%3BentryY%3D0.5%3BentryDx%3D0%3BentryDy%3D0%3B%22%20target%3D%224%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22390%22%20y%3D%22420%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22440%22%20y%3D%22370%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%228%22%20connectable%3D%220%22%20parent%3D%227%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22s_axis_tdata%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.0923%22%20y%3D%224%22%20as%3D%22geometry%22%3E%3CmxPoint%20y%3D%22-6%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%229%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BentryX%3D1%3BentryY%3D0.75%3BentryDx%3D0%3BentryDy%3D0%3BexitX%3D0%3BexitY%3D0.75%3BexitDx%3D0%3BexitDy%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22350%22%20y%3D%22480%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22220%22%20y%3D%22480%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2210%22%20connectable%3D%220%22%20parent%3D%229%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22s_axis_tready%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.1385%22%20y%3D%224%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22-14%22%20y%3D%22-14%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2211%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BexitX%3D1%3BexitY%3D0.25%3BexitDx%3D0%3BexitDy%3D0%3BentryX%3D0%3BentryY%3D0.25%3BentryDx%3D0%3BentryDy%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22470%22%20y%3D%22400%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22600%22%20y%3D%22400%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2212%22%20connectable%3D%220%22%20parent%3D%2211%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22m_axis_tvalid%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%220.0154%22%20y%3D%222%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%224%22%20y%3D%22-8%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2213%22%20edge%3D%221%22%20parent%3D%221%22%20source%3D%224%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BexitX%3D1%3BexitY%3D0.5%3BexitDx%3D0%3BexitDy%3D0%3BentryX%3D0%3BentryY%3D0.5%3BentryDx%3D0%3BentryDy%3D0%3B%22%20target%3D%223%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22390%22%20y%3D%22420%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22440%22%20y%3D%22370%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2214%22%20connectable%3D%220%22%20parent%3D%2213%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22m_axis_tdata%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.0923%22%20y%3D%22-3%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%2211%22%20y%3D%22-13%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2215%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3BexitX%3D0%3BexitY%3D0.75%3BexitDx%3D0%3BexitDy%3D0%3BentryX%3D1%3BentryY%3D0.75%3BentryDx%3D0%3BentryDy%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22600%22%20y%3D%22480%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22470%22%20y%3D%22480%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2216%22%20connectable%3D%220%22%20parent%3D%2215%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22m_axis_tready%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.0308%22%20y%3D%222%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%223%22%20y%3D%22-12%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2217%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22300%22%20y%3D%22360%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22350%22%20y%3D%22360%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2218%22%20connectable%3D%220%22%20parent%3D%2217%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22%26lt%3Bdiv%26gt%3Bclk%26lt%3B%2Fdiv%26gt%3B%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.4303%22%20y%3D%221%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%226%22%20y%3D%22-9%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2219%22%20edge%3D%221%22%20parent%3D%221%22%20style%3D%22endArrow%3Dclassic%3Bhtml%3D1%3Brounded%3D0%3B%22%20value%3D%22%22%3E%3CmxGeometry%20height%3D%2250%22%20relative%3D%221%22%20width%3D%2250%22%20as%3D%22geometry%22%3E%3CmxPoint%20x%3D%22300%22%20y%3D%22520%22%20as%3D%22sourcePoint%22%2F%3E%3CmxPoint%20x%3D%22350%22%20y%3D%22520%22%20as%3D%22targetPoint%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3CmxCell%20id%3D%2220%22%20connectable%3D%220%22%20parent%3D%2219%22%20style%3D%22edgeLabel%3Bhtml%3D1%3Balign%3Dcenter%3BverticalAlign%3Dmiddle%3Bresizable%3D0%3Bpoints%3D%5B%5D%3B%22%20value%3D%22rst%22%20vertex%3D%221%22%3E%3CmxGeometry%20relative%3D%221%22%20x%3D%22-0.3267%22%20y%3D%222%22%20as%3D%22geometry%22%3E%3CmxPoint%20y%3D%22-8%22%20as%3D%22offset%22%2F%3E%3C%2FmxGeometry%3E%3C%2FmxCell%3E%3C%2Froot%3E%3C%2FmxGraphModel%3E
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
