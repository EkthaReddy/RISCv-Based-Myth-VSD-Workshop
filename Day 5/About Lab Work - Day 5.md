# Day 5

## About the piplelined RISCV

[Link for the Lab Work on Day 5](https://myth.makerchip.com/sandbox/0BBfVh1qz/0y8hrPy) Click on the Link to view the project

The output of the Lab Work Day 5

The **Diagram**
![Diagram Of Day 5 Lab Work](https://github.com/user-attachments/assets/3bb57a62-5dac-4e2d-84c2-3c1f433deb4e)

The **Waveform**
![Waveform Of Day 5 Lab Work](https://github.com/user-attachments/assets/bca618c6-ba32-411f-873e-021c338acb85)

**1. Introduction to Pipelining**

Pipelining is a technique used in processor design to **improve instruction throughput** by overlapping the execution of multiple instructions. It divides instruction execution into discrete stages, each performing a specific task. Each stage works concurrently on different instructions, similar to an assembly line.


A **RISC-V pipelined processor** typically implements **five classic pipeline stages**:

**2. Five Stages of the Pipeline**

| Stage | Name                     | Function                                                                 |
|-------|--------------------------|--------------------------------------------------------------------------|
| IF    | Instruction Fetch        | Fetch the instruction from memory using the Program Counter (PC).       |
| ID    | Instruction Decode       | Decode the instruction and read registers from the Register File.       |
| EX    | Execute                  | Perform ALU operations or calculate memory addresses for load/store.    |
| MEM   | Memory Access            | Access data memory for load and store instructions.                     |
| WB    | Write Back               | Write the result back to the register file.                             |

![Screenshot (973)](https://github.com/user-attachments/assets/5584bbdf-c783-42e2-9367-15095ab39746)

**3. Working of Each Stage**

 **Instruction Fetch (IF)**
- Uses the PC to fetch the instruction from instruction memory.
- Increments the PC to point to the next instruction (usually `PC + 4`).
- Passes instruction and PC+4 to the next stage.

 **Instruction Decode (ID)**
- Decodes the fetched instruction to determine the opcode, funct3, funct7, rs1, rs2, and rd.
- Fetches operand values from the register file.
- Generates immediate values.
- Passes all relevant data and control signals to the Execute stage.

**Execute (EX)**
- Performs operations based on the instruction type:
  - Arithmetic operations (e.g., ADD, SUB)
  - Branch condition checking
  - Address computation for memory access
- Computes the target PC for branches and jump instructions.

**Memory Access (MEM)**
- Used for **load** (`lw`, `lh`, `lb`, etc.) and **store** (`sw`, `sh`, `sb`) instructions.
- Accesses data memory with address computed in the EX stage.

**Write Back (WB)**
- Writes the result (from ALU or memory) back to the destination register (`rd`).

**Pipeline Registers**
Between each stage, **pipeline registers** (e.g., `IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`) hold intermediate data and control signals. They ensure data flows correctly across stages without interference.

---

### Hazards in Pipelined Processor

**Data Hazards**
Occurs when instructions depend on the results of previous instructions.

**Solution**:
- **Forwarding (Bypassing)**: Uses multiplexers to forward results from later stages.
- **Stalling**: Delays instruction in ID stage until dependency is resolved.

**Control Hazards**
Occurs on branch and jump instructions due to unknown target address until EX stage.

**Solution**:
- **Branch Prediction**
- **Delayed Branch**
- **Flushing the pipeline**

**Structural Hazards**
Happens when hardware resources are insufficient for simultaneous access.

**Solution**:
- Use separate instruction and data memories (Harvard architecture).
- Add more functional units.


```

Pipeline Execution Table:

| Cycle | IF      | ID        | EX        | MEM      | WB        |
|-------|---------|-----------|-----------|----------|-----------|
| 1     | add     |           |           |          |           |
| 2     | sub     | add       |           |          |           |
| 3     | lw      | sub       | add       |          |           |
| 4     |         | lw        | sub       | add      |           |
| 5     |         |           | lw        | sub      | add       |
| 6     |         |           |           | lw       | sub       |
| 7     |         |           |           |          | lw        |
```

**That's all for Day 5 Work**
