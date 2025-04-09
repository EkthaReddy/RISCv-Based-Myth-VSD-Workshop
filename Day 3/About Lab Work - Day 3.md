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

Sure, Ektha! Here's a brief explanation about **Vectors in TL-Verilog**:

---

**What is TL-Verilog?**

**TL-Verilog (Transaction-Level Verilog)** is a **higher-level abstraction** of Verilog, designed for **hardware design and verification**, allowing more reusable and scalable designs using **pipelines, timing abstraction**, and **transactional modeling**.

---

**Vectors in TL-Verilog**

In TL-Verilog, **vectors** are similar to Verilog bit arrays (multi-bit signals), but the syntax is more abstract and clean.

**Declaring a Vector (Wire or Signal)**

```tlv
|my_scope
    $my_vector[7:0] // 8-bit vector (wire/signal)
```

- `my_vector` is an 8-bit wide signal.
- Bit positions are defined using `[MSB:LSB]` (e.g., `[7:0]` for 8 bits).

**Assigning a Value**

```tlv
/my_vector = 8'hA5   // Assign hex value A5 to my_vector
```

You can assign values like in Verilog:
- Binary: `8'b10101010`
- Hex: `8'hFF`
- Decimal: `8'd255`

---

**Accessing Vector Bits**

```tlv
/my_bit = /my_vector[3]     // Access bit 3 of my_vector
/my_slice = /my_vector[7:4] // Access upper 4 bits
```

---

**Using in Pipelines**

TL-Verilog supports pipelining natively, so you can do:

```tlv
|pipeline
    @1
        $data_in[15:0]
    @2
        /data_out = /data_in + 16'd5
```

Here:
- `@1`, `@2` represent pipeline stages.
- `data_in` is declared as a 16-bit vector.
- `data_out` is the result after processing in stage 2.

---

Summary

| Feature          | TL-Verilog Syntax             |
|------------------|-------------------------------|
| Declare vector   | `$vec[7:0]`                   |
| Assign value     | `/vec = 8'hAB`                |
| Access bit       | `/vec[2]`                     |
| Access slice     | `/vec[7:4]`                   |
| Pipeline usage   | Use `@n` blocks with vectors  |

