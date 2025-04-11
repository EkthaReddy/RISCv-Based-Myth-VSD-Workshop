# Day 4

## About The Basics of Micro Architecture of RISCv

Designing of RISCv was done by using TL Verilog and Makerchip Platform

[link for 1_to_n_sum.v Lab Work](https://myth.makerchip.com/sandbox/0gJflh798/0VmhxqD#)

In this Lab, the detailed explanation and step by step process to implement the RISCv was discussed. Every blocks of the RISCv was explained and gave a guide on how to design each.

Let us first see the Block Diagram:
![Screenshot (968)](https://github.com/user-attachments/assets/50da57b1-b868-4b6c-8fbd-508df11bcd35)

Let us view the Blocks:

## 1. Program Counter (PC)

The **Program Counter (PC)** is a fundamental register in any processor architecture. In the context of a **RISC-V single-cycle processor**, the PC holds the **address of the current instruction** and plays a crucial role in determining the **control flow** of a program.

**What do the PC do?**.
- It has an input from a **multiplexer** that selects the next address based on control logic.
- The output of the PC feeds into:
  - **Instruction Memory** (to fetch the current instruction).
  - The **Branch Adder** (to compute the target address for branches).
  - The **PC + 4 Adder** (to compute the next sequential instruction address).

The expression provided defines the behavior of the Program Counter (PC) during each clock cycle. The PC is a 32-bit register that holds the address of the current instruction being executed. It must be updated at every cycle to ensure proper instruction sequencing or redirection in the case of control-flow changes like branches.
```
pc[31:0] = reset ? 0 :
           taken_br ? br_tgt_pc :
           pc + 32'd4;
```

**Explanation of Each Component:**

1. **`reset ? 0`**  If the `reset` signal is high (`reset == 1`)then the PC is assigned the value `0`.

2. **`taken_br ? br_tgt_pc`**  
  If the `reset` signal is low and the `taken_br` (branch taken) signal is high then the PC is updated to the branch target address specified by `br_tgt_pc`.
  
3. **`pc + 32'd4`**   If neither `reset` nor `taken_br` is active then the PC is incremented by 4.
  
