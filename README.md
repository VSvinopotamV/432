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
[structure.drawio](https://github.com/user-attachments/files/27575064/structure.drawio)

Примеры корректных BCD-значений:

```text
8'h00 = 0
8'h04 = 4
8'h12 = 12
8'h24 = 24
8'h99 = 99
```
[U<mxfile host="app.diagrams.net">
  <diagram name="Страница-1" id="71pgJAMiIY7A4IGfKEe7">
    <mxGraphModel dx="729" dy="623" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-1" parent="1" style="rounded=0;whiteSpace=wrap;html=1;" value="Master" vertex="1">
          <mxGeometry height="240" width="120" x="100" y="320" as="geometry" />
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-2" parent="1" style="rounded=0;whiteSpace=wrap;html=1;" value="Slave" vertex="1">
          <mxGeometry height="240" width="120" x="600" y="320" as="geometry" />
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-3" parent="1" style="rounded=0;whiteSpace=wrap;html=1;" value="axi_bcd_filter" vertex="1">
          <mxGeometry height="240" width="120" x="350" y="320" as="geometry" />
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-4" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;exitX=1;exitY=0.25;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="220" y="400" as="sourcePoint" />
            <mxPoint x="350" y="400" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-15" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-4" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="s_axis_tvalid" vertex="1">
          <mxGeometry relative="1" x="-0.0308" as="geometry">
            <mxPoint x="-3" y="-10" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-5" edge="1" parent="1" source="lRIrzWzYxItEvFAQ7Y21-1" style="endArrow=classic;html=1;rounded=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" target="lRIrzWzYxItEvFAQ7Y21-3" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="390" y="420" as="sourcePoint" />
            <mxPoint x="440" y="370" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-14" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-5" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="s_axis_tdata" vertex="1">
          <mxGeometry relative="1" x="-0.0923" y="4" as="geometry">
            <mxPoint y="-6" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-6" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;entryX=1;entryY=0.75;entryDx=0;entryDy=0;exitX=0;exitY=0.75;exitDx=0;exitDy=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="350" y="480" as="sourcePoint" />
            <mxPoint x="220" y="480" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-13" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-6" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="s_axis_tready" vertex="1">
          <mxGeometry relative="1" x="-0.1385" y="4" as="geometry">
            <mxPoint x="-14" y="-14" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-7" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;exitX=1;exitY=0.25;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="470" y="400" as="sourcePoint" />
            <mxPoint x="600" y="400" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-12" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-7" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="m_axis_tvalid" vertex="1">
          <mxGeometry relative="1" x="0.0154" y="2" as="geometry">
            <mxPoint x="4" y="-8" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-8" edge="1" parent="1" source="lRIrzWzYxItEvFAQ7Y21-3" style="endArrow=classic;html=1;rounded=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" target="lRIrzWzYxItEvFAQ7Y21-2" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="390" y="420" as="sourcePoint" />
            <mxPoint x="440" y="370" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-11" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-8" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="m_axis_tdata" vertex="1">
          <mxGeometry relative="1" x="-0.0923" y="-3" as="geometry">
            <mxPoint x="11" y="-13" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-9" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;exitX=0;exitY=0.75;exitDx=0;exitDy=0;entryX=1;entryY=0.75;entryDx=0;entryDy=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="600" y="480" as="sourcePoint" />
            <mxPoint x="470" y="480" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-10" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-9" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="m_axis_tready" vertex="1">
          <mxGeometry relative="1" x="-0.0308" y="2" as="geometry">
            <mxPoint x="3" y="-12" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-16" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="300" y="360" as="sourcePoint" />
            <mxPoint x="350" y="360" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-17" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-16" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="&lt;div&gt;clk&lt;/div&gt;" vertex="1">
          <mxGeometry relative="1" x="-0.4303" y="1" as="geometry">
            <mxPoint x="6" y="-9" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-18" edge="1" parent="1" style="endArrow=classic;html=1;rounded=0;" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="300" y="520" as="sourcePoint" />
            <mxPoint x="350" y="520" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="lRIrzWzYxItEvFAQ7Y21-20" connectable="0" parent="lRIrzWzYxItEvFAQ7Y21-18" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" value="rst" vertex="1">
          <mxGeometry relative="1" x="-0.3267" y="2" as="geometry">
            <mxPoint y="-8" as="offset" />
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
ploading structure.drawio…]()

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
