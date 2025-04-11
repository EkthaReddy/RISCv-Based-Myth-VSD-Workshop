# Day 4

## About The Basics of Micro Architecture of RISCv

Designing of RISCv was done by using TL Verilog and Makerchip Platform

[link for 1_to_n_sum.v Lab Work](https://myth.makerchip.com/sandbox/0gJflh798/0VmhxqD#) Click on the Link to view the project.

The output Diagram and waveform generated are shown below
**Diagram** of the Lab Work on day 4
![Diagram Of Day 4 Lab Work](https://github.com/user-attachments/assets/0200d479-6b9d-43ff-9b0b-49506ccfe314)

**Waveform** of the Lab Work on Day 4
![Waveform Of Day 4 Lab Work](https://github.com/user-attachments/assets/1180c9a8-ec60-4026-87b8-a00544de03ce)

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

![Screenshot (971)](https://github.com/user-attachments/assets/4c9e662f-d1f9-446f-8955-8400033d1105)

The code for it is:
```
$is_i_instr = $instr[6:2] ==? 5'b0000x ||
                       $instr[6:2] ==? 5'b001x0 ||
                       $instr[6:2] ==? 5'b11001;
                       
         //For Instruction R
         $is_r_instr = $instr[6:2] ==? 5'b011x0 ||
                       $instr[6:2] ==? 5'b01011 ||
                       $instr[6:2] ==? 5'b10100;
         //For Instruction S
         $is_s_instr = $instr[6:2] ==? 5'b0100x;
                       
         //For Instruction B
         $is_b_instr = $instr[6:2] ==? 5'b11000;
                       
         //For Instruction J
         $is_j_instr = $instr[6:2] ==? 5'b11011;
         
         //For Instruction U
         $is_u_instr = $instr[6:2] ==? 5'b0x101;
```

**Code Explanation**
Let us take I type example to explain:
For **I Type**, we can find I type at 5 locations
![Screenshot (971)](https://github.com/user-attachments/assets/31f6c303-af37-406f-9ebb-15523e47fdac)
Let us check by row wise.
At the first row we can find $ I types, For the 1st two the `00` is same whereas the `000` and `001` is different for last bit position. So instead of writing `00_000` and `00_001` we can just take dont care at last bit position i.e., `00_00x`. Because we are using dont care the operator is being used as `==?`

**Why Use ==? Instead of ==**
`==?` allows for wildcard matching, useful when bits in an opcode group follow a pattern.

For instance: 5'b0000x matches both 00000 and 00001.

Similarly it is being followed for the rest of the instructions.

## 3. Immediate Generator

The **Immediate Generator** is a crucial component of a RISC-V processor responsible for **extracting and sign-extending immediate values** from the instruction word, depending on the **instruction format**. Immediate values are used in arithmetic operations, memory addressing, and control-flow instructions such as branches and jumps.

In the RISC-V instruction set architecture (ISA), **immediate values** are located in different bit fields across various instruction formats:

- **I-Type**
- **S-Type**
- **B-Type**
- **U-Type**
- **J-Type**

![Screenshot (972)](https://github.com/user-attachments/assets/821fe9c6-d8c0-4493-a867-c6fd2555defa)


**TL Verilog Code**
```
imm[31:0] = is_i_instr ? { {21{instr[31]}}, instr[30:20] } :
            is_s_instr ? { {21{instr[31]}}, instr[30:25], instr[11:8], instr[7]} :
            is_b_instr ? { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} :
            is_u_instr ? { instr[31], instr[30:20], instr[19:12], {12{1'b0}} } :
            is_j_instr ? { {12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0 } :
            32'b0;
```

 Explanation by Instruction Type

**I-Type Instructions**

**Immediate Format:**
```verilog
{ {21{instr[31]}}, instr[30:20] }
```
- **Bits Used:** `instr[31:20]` (12 bits)
- The most significant bit `instr[31]` is the sign bit.
- `instr[31]` is sign-extended to 21 bits to produce a 32-bit signed immediate.
- **Result:** A sign-extended 32-bit immediate.

**S-Type Instructions**

**Immediate Format:**
```verilog
{ {21{instr[31]}}, instr[30:25], instr[11:8], instr[7] }
```
- **Bits Used:**
  - `instr[31:25]` (7 bits)
  - `instr[11:7]` (5 bits)
- Together, these form a 12-bit signed immediate.
- The MSB `instr[31]` is sign-extended.

**B-Type Instructions**

**Immediate Format:**
```verilog
{ {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 }
```
- **Bits Used (in order of position):**
  - `instr[31]` (sign bit)
  - `instr[7]` (bit 11 of immediate)
  - `instr[30:25]` (bits 10 to 5)
  - `instr[11:8]` (bits 4 to 1)
  - Last bit is `0` (LSB), since branches target word-aligned addresses.
- Combined, this forms a 13-bit signed immediate (with LSB = 0), sign-extended to 32 bits.

**U-Type Instructions**

**Immediate Format:**
```verilog
{ instr[31], instr[30:20], instr[19:12], {12{1'b0}} }
```
- **Bits Used:** `instr[31:12]` (20 bits)
- Immediate is left-shifted by 12 bits (`{12{1'b0}}` padding at LSB).
- No sign extension is needed.

**J-Type Instructions**

**Immediate Format:**
```verilog
{ {12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0 }
```
- **Bits Used:**
  - `instr[31]` (sign bit)
  - `instr[19:12]`, `instr[20]`, `instr[30:25]`, `instr[24:21]`
  - LSB is always `0` to maintain alignment.
- These fields are rearranged and sign-extended.

**Default Case**
If the instruction does not match any known format, the immediate is set to zero:
```verilog
32'b0;
```

Here’s a **professional and academic-style explanation** for the Register File read and write operations based on the provided code snippet:

---

## 3. Register File Operations in a RISC-V Processor

The **Register File** in a RISC-V processor supports:
- Dual-port **read** functionality (to fetch operands).
- Single-port **write** functionality (to update results).

This section describes the **read and write logic** used to interact with the register file based on input instruction fields (`rs1`, `rs2`, and `rd`), control signals, and data values.

---

**Read Operation**

```verilog
$rf_rd_en1 = $rs1_valid;
$rf_rd_en2 = $rs2_valid;

$rf_rd_index1[4:0] = $rs1[4:0];
$rf_rd_index2[4:0] = $rs2[4:0];

$src1_value[31:0] = $rf_rd_data1[31:0];
$src2_value[31:0] = $rf_rd_data2[31:0];
```

 **Explanation:**
- `$rs1_valid` and `$rs2_valid`: Control signals that indicate whether the instruction uses the source registers `rs1` and `rs2`.
- `$rf_rd_en1` and `$rf_rd_en2`: Enable signals to initiate a read from the register file for `rs1` and `rs2`.
- `$rf_rd_index1` and `$rf_rd_index2`: Index selectors for reading the values from the register file. These are 5-bit fields because the RISC-V ISA supports 32 registers (2⁵ = 32).
- `$rf_rd_data1` and `$rf_rd_data2`: The actual 32-bit register data read from the register file.
- `$src1_value` and `$src2_value`: These values hold the operand data used by the ALU or other logic units in the datapath.

This enables the processor to fetch operands for any instruction that requires register-based computation.

---

 **3.2 Write Operation**

```verilog
$rf_wr_en = $rd && $rd_valid;
$rf_wr_index[4:0] = $rd[4:0];
$rf_wr_data[31:0] = $result[31:0];
```

 **Explanation:**
- `$rd`: Destination register field from the instruction.
- `$rd_valid`: Control signal indicating that the instruction writes to a register.
- `$rf_wr_en`: This signal is asserted only if `$rd_valid` is true and a valid destination register (`rd`) is provided. This ensures no write happens if the instruction does not produce a result (e.g., store, branch).
- `$rf_wr_index`: Specifies the destination register index to which the result will be written.
- `$rf_wr_data`: The 32-bit result computed by the ALU or load data from memory is written to the register file.

> **Note:** Register x0 (index 0) in RISC-V is hardwired to zero. It should not be overwritten. A conditional check (`$rd != 0`) must be added in the implementation to enforce this constraint.

---
