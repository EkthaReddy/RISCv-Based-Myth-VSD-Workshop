# Day 2

### Application Binary Interface (ABI) 

**Introduction**

An **Application Binary Interface (ABI)** defines the low-level interface between two program modules: typically, between **compiled application code** and the **operating system** or **hardware platform**. While an API (Application Programming Interface) defines how source code interacts with libraries or services, the ABI governs how binary code is executed and linked.

ABIs are essential for ensuring **binary compatibility**—allowing pre-compiled programs to run on different systems or to work with system libraries without recompilation.

**ABI Interface Levels**

The ABI can be understood at various levels, each critical for software development, compiler design, and OS interaction.
![Screenshot (992)](https://github.com/user-attachments/assets/fbcf33f3-8eac-4d36-a045-929a83606c66)

**Processor Instruction Set Architecture (ISA)**

- Defines **machine-level instructions** the processor understands.
- Specifies registers, data types, and memory access.
- Ensures compiled code executes correctly on the target processor.
  
🔹 Example: RISC-V, x86, ARM.

This Day 2 lab explaned clearly the 3 question, which were:
**1. Why we need 32 bit register**
**2. How ABI Accesses through memory**
**3. How to load data into system**

So, let us view each question one by one:
For the **1st one**,
![Uploading Screenshot (995).png…]()

The main reason is that the source register value is 5 bit long. Which are same for every instruction types. So, according to the formula 2^n = 2^5 = 32 bits.

Other reasons are:
**Data Representation**
A 32-bit register can represent unsigned integers from 0 to 4,294,967,295 and signed integers from –2,147,483,648 to 2,147,483,647. This size is suitable for many general-purpose applications, including arithmetic operations and address calculations.

**Addressing Memory**
In a 32-bit architecture, memory addresses are also 32 bits wide. This allows the system to address up to 4 GB of memory (2³² bytes), which is sufficient for many embedded and general-purpose systems.

for the **2nd one**,
It is because of the interface. Interface is used to provide efficient functionality of the operation. At this level the other constraints like timimg, routing, etc are ignored.
For the Application program to run on hardware, we need interface. This interface runs on different levels.
![Screenshot (992)](https://github.com/user-attachments/assets/f3e839b1-a421-41c4-9623-c96d8bd8bfbf)

For the **3rd one**,
It is done through different types of instructions present in riscv

Let us view the Instruction type in detail especially about the format

**Instruction Formats in ABI Context**

An **Instruction Format** specifies how a machine-level instruction is divided into fields such as operation codes, registers, and immediate values. These formats are standardized by the **ABI** to ensure compatibility between hardware and software components in systems like **RISC-V**.

**R-Type Format (Register Type)**

- Used for: Arithmetic and logical operations between **registers**.

**Bit Fields:**
```
| 31–25 | 24–20 | 19–15 | 14–12 | 11–7 | 6–0 |
| funct7 | rs2  | rs1   | funct3 | rd  | opcode |
```

| Field     | Width | Description                          |
|-----------|--------|--------------------------------------|
| `opcode`  | 7 bits | Identifies instruction type          |
| `rd`      | 5 bits | Destination register                 |
| `funct3`  | 3 bits | Specifies operation subtype          |
| `rs1`     | 5 bits | Source register 1                    |
| `rs2`     | 5 bits | Source register 2                    |
| `funct7`  | 7 bits | Further distinguishes the operation  |

**Example:**
```assembly
add x5, x1, x2  // x5 = x1 + x2
```

**I-Type Format (Immediate Type)**

- Used for: Arithmetic with constants, **load**, **system calls**, etc.

**Bit Fields:**
```
| 31–20     | 19–15 | 14–12 | 11–7 | 6–0 |
| imm[11:0] | rs1   | funct3 | rd  | opcode |
```

| Field     | Width | Description                        |
|-----------|--------|------------------------------------|
| `imm`     | 12 bits | Immediate constant (signed)      |
| `rs1`     | 5 bits  | Source register                  |
| `funct3`  | 3 bits  | Operation subtype                |
| `rd`      | 5 bits  | Destination register             |
| `opcode`  | 7 bits  | Instruction type                 |

**Example:**
```assembly
addi x5, x1, 10  // x5 = x1 + 10
```

**S-Type Format (Store Type)**

- Used for: **Storing** register data to memory.

**Bit Fields:**
```
| 31–25    | 24–20 | 19–15 | 14–12 | 11–7    | 6–0 |
| imm[11:5]| rs2   | rs1   | funct3 | imm[4:0] | opcode |
```

| Field     | Width | Description                          |
|-----------|--------|--------------------------------------|
| `imm`     | 12 bits| Split into two parts (offset)        |
| `rs1`     | 5 bits | Base register (address)              |
| `rs2`     | 5 bits | Data register to store               |
| `funct3`  | 3 bits | Store type (byte, word, etc.)        |
| `opcode`  | 7 bits | Instruction type                     |

**Example:**
```assembly
sw x6, 8(x1)  // Store x6 at memory[x1 + 8]
```

**B-Type Format (Branch Type)**

- Used for: **Conditional branches** (e.g., `beq`, `bne`).

**Bit Fields:**
```
| 31 | 30–25 | 24–20 | 19–15 | 14–12 | 11 | 10–8 | 7 | 6–0 |
| imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode |
```

| Field     | Width | Description                            |
|-----------|--------|----------------------------------------|
| `imm`     | 13 bits| Signed offset for branch target        |
| `rs1`     | 5 bits | First operand register                 |
| `rs2`     | 5 bits | Second operand register                |
| `funct3`  | 3 bits | Branch condition type (`beq`, etc.)    |
| `opcode`  | 7 bits | Instruction type                       |

**Note:** Immediate bits are scattered and reconstructed during decoding.

**Example:**
```assembly
beq x1, x2, label  // If x1 == x2, branch to label
```

**U-Type Format (Upper Immediate Type)**

- Used for: **Loading large constants** into high bits.

**Bit Fields:**
```
| 31–12        | 11–7 | 6–0 |
| imm[31:12]   | rd   | opcode |
```

| Field     | Width   | Description                    |
|-----------|----------|--------------------------------|
| `imm`     | 20 bits  | Upper part of immediate value  |
| `rd`      | 5 bits   | Destination register           |
| `opcode`  | 7 bits   | Instruction type               |

**Example:**
```assembly
lui x5, 0x10000  // Load upper 20 bits
```

**J-Type Format (Jump Type)**

- Used for: **Unconditional jumps** like `jal`.

**Bit Fields:**
```
| 31 | 30–21 | 20 | 19–12 | 11–7 | 6–0 |
| imm[20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode |
```

| Field     | Width   | Description                       |
|-----------|----------|-----------------------------------|
| `imm`     | 21 bits  | Signed offset to jump location    |
| `rd`      | 5 bits   | Destination register              |
| `opcode`  | 7 bits   | Instruction type                  |

**Note:** Immediate bits are reordered during decoding.

**Example:**
```assembly
jal x1, label  // Jump to label, save return addr in x1
```

![Screenshot (996)](https://github.com/user-attachments/assets/f3273b1c-f78d-461b-9f19-4468908e05fc)

**Conclusion**

In summary, the **ABI is a crucial contract** between compiled applications and the environment in which they execute. Understanding the ABI is essential for developers working with **low-level programming**, **compilers**, **operating systems**, or **hardware platforms**. It guarantees that different components of a system can interact correctly and efficiently at the binary level.




















`leafpad 1to9_custom.c`

`leafpad load.S`

`cat 1to9_custom.c`

`cat load.S`

`riscv64-unknown-elf-gcc -ofast -mabi=lp64 -march=rv64i -o 1to9_custom.o 1to9_custom.c load.S`

`spike pk 1to9_custom.o`

`riscv64-unknown-elf-objdump -d 1to9_custom.o | less`

`cd`

`git clone https://github.com/kunalg123/riscv_workshop_collaterals.git`

`cd riscv_workshop_collaterals`

`ls -ltr`

`cd labs`

` ls -ltr`

`vim picorv32.v`

`less picorv32.v

`vim testbench.v`

`vim rv32im.sh`

`vim 1to9_custom.c`

`./rv32im.sh`

`ls -ltr`

`vim firmware.hex`

`vim firmware32.hex`
