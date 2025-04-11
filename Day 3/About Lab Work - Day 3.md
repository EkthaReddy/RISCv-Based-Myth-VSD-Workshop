# Day 3

## About the Labwork in Makerchip
Makerchip is a platform that provides free and instant access to tools for circuit design, including open-source and proprietary tools, accessible directly from your browser or desktop, and is developed by Redwood EDA, LLC.

The link for the lab work is given below:

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

> For the below I have referred to Online sources

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


## Sequential Circuits 

A **sequential circuit** is a type of digital circuit in which the output depends not only on the current inputs but also on the history of inputs. This is achieved by incorporating memory elements such as flip-flops or latches, allowing the circuit to store past states.

**Key Characteristics:**
- The output is a function of **current inputs** and **previous states**.
- Requires **clock signals** for synchronization (in synchronous circuits).
- Capable of **storing information**, making them useful in state-based systems.

**Types of Sequential Circuits:**

1. **Synchronous Sequential Circuits**  
   - State transitions are governed by a clock signal.  
   - Examples: Counters, Shift Registers, Finite State Machines (FSMs).

2. **Asynchronous Sequential Circuits**  
   - Do not use a clock; state changes depend directly on input changes.  
   - Less common due to complexity and risk of unstable behavior.

**Common Components:**
- Flip-Flops (D, T, JK, SR)
- Latches
- Registers
- Counters
- State Machines


## Pipelining in TL-Verilog

**Definition:**  
Pipelining in TL-Verilog is the technique of **breaking logic into sequential stages** (executed over multiple clock cycles), where TLV automatically handles **register insertion and value propagation**.


**Time Abstraction in TL-Verilog**

**Temporal abstraction** means separating **what the logic does** from **when it does it**.


**Pythagoras Theorem Example in TLV**

We’ll calculate:

\[
c = \sqrt{a^2 + b^2}
\]

We assume:
- Inputs: `a`, `b`
- Output: `c`

---

**Version 1: 3-Stage Pipelining**

```tlv
|pipeline
  @1
    $a_sq = $a * $a;
    $b_sq = $b * $b;
  @2
    $sum = $a_sq + $b_sq;
  @3
    $c = sqrt($sum);
```

**Clock Cycles**

| Clock Cycle | Operation                          |
|-------------|------------------------------------|
| Cycle 1     | Compute a² and b²                  |
| Cycle 2     | Add a² + b²                        |
| Cycle 3     | Compute √(a² + b²) and get `c`     |

---

**Version 2: 5-Stage Pipelining**

```tlv
|pipeline
  @1
    $a_sq = $a * $a;
  @2
    $b_sq = $b * $b;
  @3
    $sum = $a_sq + $b_sq;
  @4
    $temp = $sum; // pass-through stage
  @5
    $c = sqrt($temp);
```

**Clock Cycles**

| Clock Cycle | Operation                          |
|-------------|------------------------------------|
| Cycle 1     | Compute a²                         |
| Cycle 2     | Compute b²                         |
| Cycle 3     | Add a² + b²                        |
| Cycle 4     | Pass-through (for balancing)       |
| Cycle 5     | Compute √(a² + b²) and get `c`     |

---
So,

```tlv
$z = $a + $b;
```

Then you can shift this logic to any stage:

```tlv
@1
  $z = $a + $b;
```

or

```tlv
@3
  $z = $a + $b;
```

👉 No need to rewrite the logic — only change the stage.

---

**Do Different Stages Affect Behavior?**

Yes, **timing behavior** is affected. **Functional behavior remains the same** if all inputs are properly propagated and dependencies are maintained.

Same logic across different pipeline stages:

- **Later stages → more delay**
- **Earlier stages → faster response**
- But **output value stays same**, just available at a different cycle.

**TLV Syntax Recap**

```tlv
|pipeline
  @1
    $x = $a + $b;
  @2
    $y = $x * $c;
```

- `|pipeline`: block indicating a pipeline structure
- `@n`: pipeline stage `n` (each `@` = 1 clock cycle delay)
- `$x`, `$y`: pipeline (latched) variables

---


**Comparison: 3-stage vs 5-stage**

| Feature                | 3-Stage                         | 5-Stage                              |
|------------------------|---------------------------------|--------------------------------------|
| Functional Output      | √(a² + b²)                      | √(a² + b²)                           |
| Output Availability    | After 3 cycles                  | After 5 cycles                       |
| Timing Control         | Medium                          | More fine-grained                    |
| Pipeline Depth         | Shallow                         | Deeper (used in processors for freq)|
| Complexity             | Less                            | More                                |

 **Conclusion:**  
Both compute the same `c`, but the 5-stage version spreads logic more thinly for **higher clock frequency**, which is **useful in performance-optimized systems** like **CPU pipelines**.


**1. Symbol Prefixes and Delimitation in TL-Verilog**

**Symbol Prefixes**

TL-Verilog employs symbolic prefixes to distinguish different categories of signals and constructs. These symbols are an essential part of the language syntax and directly reflect the role of each signal within the design.

| **Prefix** | **Type**                  | **Purpose**                                                                 |
|------------|---------------------------|------------------------------------------------------------------------------|
| `$`        | Pipeline signal           | Used for values computed and passed through pipeline stages. These are automatically latched at each stage. |
| `%`        | State signal              | Represents values that persist across cycles, typically used for state machines and counters. |
| `!`        | Combinational signal      | Temporary or intermediate values used within a stage and not registered.    |
| `&`        | Keyword or control signal | Signals that control flow or indicate conditions, e.g., `&reset`, `&valid`. |
| `@`        | Pipeline stage            | Indicates the temporal pipeline stage number in which logic executes.       |
| `|`        | Structural block          | Denotes hierarchy or modules, such as `|pipeline`, `|root`.                 |
| `/`        | Comment                   | Line comments begin with `/` (similar to `//` in Verilog).                  |
| `#`        | Macro / preprocessor      | Used for macro definitions and directives.                                  |

**Delimitation**

TL-Verilog is indentation-sensitive and does not require `begin`/`end` blocks like SystemVerilog. Structural hierarchy and sequential logic flow are defined by indentation levels and block symbols:

```tlv
|pipeline
  @1
    $sum = $a + $b;  // Logic within stage 1
  @2
    $out = $sum * 2; // Logic within stage 2
```

Each indented level signifies scope and hierarchical containment.

---

**2. Tokens and Identifiers**

A **token** in TL-Verilog is the smallest element of syntax, typically representing a signal name, operator, keyword, or literal.

**Identifiers**

An identifier represents the name of a signal or variable. TL-Verilog enforces the following rules:

- Must begin with a **letter** (`A–Z`, `a–z`) or **underscore (`_`)**.
- May contain **letters**, **digits** (`0–9`), and **underscores**.
- **Cannot begin with a digit**.

**Valid Identifiers**

```tlv
$sum         // valid
$sum_value   // valid
$a1          // valid
%counter     // valid
&reset       // valid
```

**Invalid Identifiers**

```tlv
$1a          // invalid – cannot start with a digit
$123         // invalid – interpreted as a numeric literal, not a signal
```

Identifiers are case-sensitive.

---

**3. Signal Declarations in TL-Verilog**

TL-Verilog does not require explicit declarations for most signals. Instead, the signal type is inferred from its prefix.

**Pipeline Signal (`$`)**

Pipeline signals represent values passed and latched across pipeline stages. Each assignment is automatically stored in a register at the end of the specified pipeline stage.

```tlv
$sum = $a + $b;
```

This indicates that `$sum` will be registered and available in the next stage.

**State Signal (`%`)**

State signals are persistent across cycles, suitable for use in state machines, counters, and accumulators.

```tlv
%counter += 1;
```

This increments the `%counter` state variable every cycle.

**Combinational Signal (`!`)**

Combinational signals are temporary within a stage and not registered. They do not persist beyond the stage in which they are defined.

```tlv
!temp = $a * $b;
```

`!temp` is used for immediate computations without introducing pipeline latency.

**Keyword/Control Signal (`&`)**

Keyword signals are commonly used for control purposes such as enable, reset, or valid flags. They are often passed through the pipeline explicitly.

```tlv
&valid
  $result = $a + $b;
```

The computation of `$result` occurs only when `&valid` is asserted.

---

**4. Numbers with Tokens – Guidelines**

**Acceptable Usage**

- Numbers are permitted **after** the first character in identifiers.
- Useful for naming signal groups or versions.

```tlv
$sum1      // valid
$stage2    // valid
%state3    // valid
```

**Prohibited Usage**

- Identifiers **cannot begin with a digit**.
- Tokens such as `$123` are interpreted as **numeric literals** (constant numbers), not variable names.

```tlv
$1a        // invalid
$123       // invalid – treated as number, not identifier
```

**Recommendation**

Avoid leading digits in all identifiers to ensure clarity and conformance to syntax rules.

---

**5. Numeric Identifiers**

TL-Verilog supports numeric literals similar to Verilog, but these are distinct from signal names.

**Valid Numeric Tokens**

```tlv
42            // Decimal
4'd9          // 4-bit decimal
8'b10101010   // 8-bit binary
16'hABCD      // 16-bit hexadecimal
```

These should **not** be prefixed with `$`, `%`, `!`, or `&` when used as constants.

```tlv
$sum = 4'd5 + $value; // Correct usage
```

Using a numeric literal like `$123` implies a misunderstanding between signal names and constants.

---

**Summary**

| Element         | Correct Format             | Notes                                              |
|------------------|-----------------------------|----------------------------------------------------|
| Pipeline Signal  | `$signal_name`             | Latched at each stage                              |
| State Signal     | `%state_var`               | Persistent across cycles                           |
| Comb. Signal     | `!temp_signal`             | Temporary within a stage                           |
| Control Signal   | `&reset`, `&enable`        | Used to control pipeline logic                     |
| Stage            | `@n`                       | Denotes temporal stage (e.g., `@1`, `@2`)          |
| Identifier Rules | Must not start with digit  | Letters/digits/underscores allowed                 |
| Numeric Literals | `4'd10`, `16'hABCD`        | Used for constants, not prefixed with symbols      |


**That's all for Day 3 Lab**

Go to [Day 4 lab](https://github.com/EkthaReddy/RISCv-Based-Myth-VSD-Workshop/blob/main/Day%204/About%20Lab%20Work%20-%20Day%204.md)
