# Day 3

## About the Labwork in Makerchip
Makerchip is a platform that provides free and instant access to tools for circuit design, including open-source and proprietary tools, accessible directly from your browser or desktop, and is developed by Redwood EDA, LLC.

The link for the lab work is given below:

Links:


|S NO.| Lab Name | Link for the assignment |
|-----|----------|-------------------------|
| 1. |Combinational Calculator | [Combinational Calculator in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/0JZhqnj)|
|2. | Fibonacci Sequence Generator|[Fibonacci Sequence Generator in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/0O7hpk5)|
|3.| Pythogoras Theorem | [Pythogoras Theorem in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/0Y6hLXm)|
|4.| Sequential Calculator | [Sequential Calculator in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/0Z4h5Yz)|
|5.| Pipeline Error Detector | [Pipeline Error Detector in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/01jhMXK)|
|6.| Pipelined Sequential Calculator With Counter| [Pipelined Sequential Calculator With Counter in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/02RhpQo)|
|7.| Pipelined Sequential Calculator With Counter - with 2nd stage| [Pipelined Sequential Calculator With Counter - with 2nd stage](https://www.makerchip.com/sandbox/0jRfjhnQv/03lhpv8)|
|8.| Counter| |
|9.| Pythagoras Theorem 3 Dimensional|[Pythagoras Theorem 3 Dimensional in Makerchip](https://www.makerchip.com/sandbox/0jRfjhnQv/066hrJO)|

## Boolean Operators

Sure! Here's a brief explanation of **Digital Logic Boolean Operators**:

**What are Boolean Operators?**
Boolean operators are the basic building blocks of **digital logic circuits**. They operate on binary values (0 and 1) and are used to make decisions based on logic.

---

**Common Boolean Operators:**

| Operator | Symbol | Description | Truth Table (A, B → Output) |
|----------|--------|-------------|------------------------------|
| **AND**  | `A · B` or `A & B` | True if **both** inputs are 1 | 00→0, 01→0, 10→0, 11→1 |
| **OR**   | `A + B` or `A | B` | True if **at least one** input is 1 | 00→0, 01→1, 10→1, 11→1 |
| **NOT**  | `~A` or `!A`       | Inverts the input (1→0, 0→1) | A=0→1, A=1→0 |
| **NAND** | `~(A · B)`         | Opposite of AND               | 00→1, 01→1, 10→1, 11→0 |
| **NOR**  | `~(A + B)`         | Opposite of OR                | 00→1, 01→0, 10→0, 11→0 |
| **XOR**  | `A ⊕ B`            | True if inputs are **different** | 00→0, 01→1, 10→1, 11→0 |
| **XNOR** | `~(A ⊕ B)`         | True if inputs are **same**      | 00→1, 01→0, 10→0, 11→1 |

---

![Screenshot (941)](https://github.com/user-attachments/assets/2300911d-d1d0-473e-9198-a17f0f885364)


**Applications:**
- Used in **digital circuits**, **processors**, **decision-making logic**, **control systems**, etc.
- Helps in simplifying logic using **Boolean algebra**.

## Combinational Circuit:

A Combinational Circuit is a type of digital circuit where the output depends only on the current inputs — there is no memory or feedback involved.

** Examples:**
- Adders (Half Adder, Full Adder)
- Multiplexers
- Decoders
- Encoders
- Comparators

**What is TL-Verilog?**

**TL-Verilog (Transaction-Level Verilog)** is an abstraction layer over SystemVerilog that simplifies hardware design by separating functionality from timing. It helps structure designs better, especially for **combinational and pipelined logic**.

It uses a clean syntax, focusing more on **what** the hardware should do rather than **how** it's done at the gate level.

**2:1 Multiplexer (MUX 2:1) in TL-Verilog**

 **Description:**
A **2:1 multiplexer** selects **one of two data inputs** based on a **single control signal (`sel`)**.

**TL-Verilog Code:**
```tlv
|main
    @1
        $out = $sel ? $in1 : $in0;
```

**Explanation:**
- `@1`: Defines the pipeline stage (can be `@0` if no pipeline).
- `$sel`: Select signal.
- `$in0`, `$in1`: Input data lines.
- `$out`: Output line.
- The ternary operator (`? :`) chooses between `$in0` and `$in1` based on `$sel`.

---

**4:1 Multiplexer (MUX 4:1) in TL-Verilog**

**Description:**
A **4:1 MUX** selects one of four inputs based on **2-bit select lines (`sel[1:0]`)**.

**TL-Verilog Code:**
```tlv
|main
    @1
        $out =
            $sel == 2'b00 ? $in0 :
            $sel == 2'b01 ? $in1 :
            $sel == 2'b10 ? $in2 :
                            $in3;
```

**Explanation:**
- `$sel` is a 2-bit input that selects one of the four inputs.
- Based on the value of `$sel`, the corresponding input is assigned to `$out`.

---

**Inverter in TL-Verilog**

**Description:**
An **inverter** is a NOT gate that **flips** the binary input.

**TL-Verilog Code:**
```tlv
|main
    @1
        $out = ~$in;
```

**Explanation:**
- `~$in`: Bitwise NOT (inverts the input signal).
- `$out` gets the inverted value of `$in`.

---

**Vectors in TL-Verilog**

**Description:**
A **vector** in TL-Verilog is a group of bits used to represent **multi-bit data** like binary numbers, buses, or signals.

**Declaring a 4-bit Vector Example:**
```tlv
$my_bus[3:0] = 4'b1010;
```

**Using Vectors:**
```tlv
|main
    @1
        $sum[3:0] = $a[3:0] + $b[3:0];
```

**Explanation:**
- `$my_bus[3:0]`: Declares a 4-bit vector.
- Bit slicing and concatenation work similarly to SystemVerilog.
- Vectors are very useful in designing **adders**, **multiplexers**, **ALUs**, etc.

---

**Summary Table:**

| Component | TL-Verilog Usage                            | Purpose                                      |
|-----------|----------------------------------------------|----------------------------------------------|
| 2:1 MUX   | `$out = $sel ? $in1 : $in0;`                | Selects 1 of 2 inputs                        |
| 4:1 MUX   | `case ($sel) ...` or nested ternary         | Selects 1 of 4 inputs                        |
| Inverter  | `$out = ~$in;`                              | Inverts input bit                           |
| Vector    | `$bus[3:0] = value;`                        | Handles multi-bit data                      |
