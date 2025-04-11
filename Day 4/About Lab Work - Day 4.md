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
  
## 2. Decoder

The **Decoder** is a critical component in the instruction fetch and execution pipeline of a RISC-V single-cycle processor. It is responsible for interpreting the binary instruction fetched from memory and generating the appropriate control signals required by other components in the datapath to execute that instruction correctly.

**What does the Decoder do?**

The Decoder takes the **instruction word** as input—typically a 32-bit binary value fetched from **Instruction Memory (IMem)**—and performs the following key functions:

- **Extracts the opcode** and identifies the instruction type (R-type, I-type, S-type, B-type, U-type, J-type).
- **Generates control signals** that guide the operation of:
  - The **Register File** (for read/write operations).
  - The **ALU** (to select the correct operation like add, subtract, shift, etc.).
  - The **Data Memory** (for read/write enables).
  - The **Multiplexers** (to choose between register values, immediate values, or addresses).
- **Extracts fields** from the instruction such as `rs1`, `rs2`, `rd`, `funct3`, `funct7`, and **immediate values**, which are then passed to the appropriate modules.


## RISC-V Instruction Formats Explained

RISC-V instructions are fixed at **32 bits**, and each instruction follows one of six basic formats based on its function. These formats define how the instruction's bits are split into fields like **register operands**, **immediate values**, **opcode**, and **function specifiers**.

---

**R-Type (Register Type)**

**Purpose:**
R-type instructions perform **arithmetic and logical operations** where **both operands come from registers**, and the result is also stored in a register.

**Format:**

```
| funct7 | rs2 | rs1 | funct3 | rd | opcode |
|  7-bit | 5b  | 5b  |  3-bit | 5b|  7-bit |
```

**Fields:**
- `opcode` (7 bits): Identifies this as an R-type instruction (`0110011`)
- `rd`: Destination register (where result is stored)
- `funct3`: Selects a specific operation
- `rs1`: First source register
- `rs2`: Second source register
- `funct7`: Further helps specify the operation (e.g., differentiate `add` vs. `sub`)

**Example Instructions:**
```assembly
add x5, x1, x2     // x5 = x1 + x2
sub x6, x3, x4     // x6 = x3 - x4
and x7, x1, x2     // x7 = x1 & x2 (bitwise AND)
or  x8, x1, x2     // x8 = x1 | x2 (bitwise OR)
sll x9, x1, x2     // x9 = x1 << x2 (shift left logical)
```

---

## **3.2 I-Type (Immediate Type)**

**Purpose:**
I-type instructions use an **immediate constant value**. They're used for:
- Arithmetic with immediate values
- Load operations from memory
- System calls and jumps

**Format:**

```
| imm[11:0] | rs1 | funct3 | rd | opcode |
|  12-bit   | 5b  |  3-bit | 5b|  7-bit  |
```

**Fields:**
- `imm[11:0]`: 12-bit immediate (sign-extended)
- `rs1`: Register source operand
- `rd`: Destination register
- `funct3`, `opcode`: Determine the exact operation

**Example Instructions:**
```assembly
addi x5, x1, 10     // x5 = x1 + 10
lw   x6, 0(x1)      // x6 = MEM[x1 + 0]
jalr x0, x1, 0      // Jump to address in x1 (used for function return)
andi x7, x2, 0xF0   // x7 = x2 & 0xF0
```

---

**S-Type (Store Type)**

**Purpose:**
S-type instructions store data **from a register to memory**. These are used for store operations like `sw`, `sb`, `sh`.

**Format:**

```
| imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |
|   7-bit   | 5b  | 5b  |  3-bit |   5-bit  | 7-bit  |
```

The immediate is split into two parts and **combined later** during decoding.

**Fields:**
- `imm[11:0]`: Combined 12-bit signed offset (used for memory address)
- `rs1`: Base register for address
- `rs2`: Source register (data to be stored)
- `funct3`, `opcode`: Define the store operation

**Example Instructions:**
```assembly
sw x5, 8(x1)        // MEM[x1 + 8] = x5
sh x6, -4(x2)       // Store half-word
sb x7, 0(x3)        // Store byte
```

---

**B-Type (Branch Type)**

**Purpose:**
B-type instructions are **conditional branch** instructions. Based on a comparison of two registers, they may **change the program counter (PC)** to a new address.

**Format:**

```
| imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode |
|     7-bit    | 5b  | 5b  |  3-bit |     5b     |  7-bit |
```

The immediate field is split and **reassembled** during instruction decode. It's a **signed offset** used to compute the branch target address.

**Fields:**
- `rs1`, `rs2`: Registers to compare
- `imm[12:1]`: Branch offset (signed and multiplied by 2)
- `funct3`, `opcode`: Specify branch condition

**Example Instructions:**
```assembly
beq x1, x2, label   // If x1 == x2, branch to label
bne x3, x4, label   // If x3 != x4, branch
blt x5, x6, label   // If x5 < x6, branch
bge x7, x8, label   // If x7 >= x8, branch
```

---

**U-Type (Upper Immediate Type)**

### **Purpose:**
U-type instructions are used to load a 20-bit constant into the upper 20 bits of a register. Used mainly in **address calculations**.

**Format:**

```
| imm[31:12]         | rd | opcode |
|      20-bit        | 5b | 7-bit  |
```

**Fields:**
- `imm[31:12]`: Immediate value shifted left by 12 bits
- `rd`: Destination register
- `opcode`: Type of U-instruction

**Example Instructions:**
```assembly
lui x5, 0x00010      // x5 = 0x00010000
auipc x6, 0x00020    // x6 = PC + 0x00020000
```

---

**J-Type (Jump Type)**

**Purpose:**
Used for **unconditional jumps**, such as function calls or jump to labels. Stores the **return address in a register** (typically `x1` or `ra`).

**Format:**

```
| imm[20|10:1|11|19:12] | rd | opcode |
|       20-bit imm      | 5b |  7-bit |
```

The 20-bit immediate is sign-extended and multiplied by 2, added to the PC to get the jump target.

**Fields:**
- `imm[20:1]`: Immediate offset (jump target relative to PC)
- `rd`: Register to hold return address (`PC + 4`)
- `opcode`: Jump type

**Example Instructions:**
```assembly
jal x1, 100         // x1 = PC + 4, PC = PC + 100
jal x0, 200         // Unconditional jump (no return address saved)
```
