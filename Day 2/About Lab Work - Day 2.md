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


### C Program Using ASM Language

**ASM (Assembly Language)** is a low-level programming language that provides a direct correspondence between the instructions in the code and the instructions executed by a computer's CPU. It is one step above machine code (binary), and one step below high-level languages like C or Python.

Let us see on **Lab Work of Day 2**,

First write the C program on the leafpad then save as `1to9_custom.c`. Open terminal and give the command `$leafpad 1to9_custom.c`.

![Screenshot (1015)](https://github.com/user-attachments/assets/a4123bbe-53b7-42b1-8997-5d2bc819cca6)

Then again write the code for [load.S] and give this command `$leafpad load.S`
![Screenshot (1016)](https://github.com/user-attachments/assets/61e2aa55-8cee-4373-81d4-1d0f17a47d54)

Then to view the code give `$cat 1to9_custom.c` then `$cat load.S`
![Screenshot (1003)](https://github.com/user-attachments/assets/f58f9eee-0375-428c-82d4-88676d3037ad)

Provide the command `$riscv64-unknown-elf-gcc -ofast -mabi=lp64 -march=rv64i -o 1to9_custom.o 1to9_custom.c load.S` then $`spike pk 1to9_custom.o` to debug. To view the main instructions and assemly language give `$riscv64-unknown-elf-objdump -d 1to9_custom.o | less`
![Screenshot (1014)](https://github.com/user-attachments/assets/ff2f03de-4d85-4238-bc12-4b207005638d)

Now let us view the verilog code and testbench for the **RISCV**
Give `$cd`

Then clone the repository to get the contents downloaded on the vm to access the RISCv Code in Verilog Language, to do so give `$git clone https://github.com/kunalg123/riscv_workshop_collaterals.git`

Then give `$cd riscv_workshop_collaterals`

To get the listing under collaterals give `$ls -ltr`

Then access labs from `$cd labs`

Again go to listing `$ls -ltr` and type `$vim picorv32.v` to get the Verilog code for the RISCV. Or else we can use this aswell `$less picorv32.v
![Screenshot (1006)](https://github.com/user-attachments/assets/75dd72b4-4af1-4bab-9319-7b86df24d3fa)

To view testbench `$vim testbench.v`
![Screenshot (1007)](https://github.com/user-attachments/assets/88520eea-678d-4f5e-b452-b24ed159ba59)
The hex code can be see here in testbench 
![Screenshot (1008)](https://github.com/user-attachments/assets/d8d7c98b-7087-48a8-ae43-6d60e8853154)

Again to view the instructions commanded to get the ouput `$vim rv32im.sh`
![Screenshot (1009)](https://github.com/user-attachments/assets/d10161e3-f1c8-43a3-b192-421701c3b81f)

We can change the number of count from 2 to 3 by changing directly through using the vm `$vim 1to9_custom.c`
![Screenshot (1012)](https://github.com/user-attachments/assets/f794c56f-0cc3-4130-aea1-e715bdb42ecb)

To get the outputof updated C code type `$./rv32im.sh`
![Screenshot (1013)](https://github.com/user-attachments/assets/6cbfe0f6-f663-447d-b30f-bcdce5798c75)

View listing `$ls -ltr` to get the hexadecimal value from assembly code by using command `$vim firmware.hex`. 
![Screenshot (1010)](https://github.com/user-attachments/assets/2d0324f2-4ddf-49cd-a00f-6f4a27df69c4)

Similarly, to view the binary value use `$vim firmware32.hex`
![Screenshot (1011)](https://github.com/user-attachments/assets/6b807ed7-d930-47b2-8693-47f22121a161)

