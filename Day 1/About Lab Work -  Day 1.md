# Day 1
## Introduction of the workshop

In Day 1, it is detaily explained about how can the C code run on hardware.

For the C program to run on system (hardware), the process is involved where C code result is compiled into the assembly language where the machine translates it into the hexadecimal format and then to binary format which is 0's and 1's. Then, the binary format helps to convert them into layout.

All of this has to be done via interface, i.e., the HDL is used to create specification and then later the specification is implemented through RTL.

![image](https://github.com/user-attachments/assets/2bcfd890-afaa-4502-a849-50668bfe66d8) 

The flowchart is such this:

```

C program -> C code result -> compile into assembly language -> convert into machine language (Binary format) -> Layout -> Hardware  
                                                                                                                                     
           |                                                                                                             |           
           |                                                                                                             |           
           |-------------------------------------------------------------------------------------------------------------|           
                                                            |                                                                        
                                                            |                                                                        
                                                            |                                                                        
                                                     -> Interface is used in this part 
                                                     (HDL -> to create specification -> implement using RTL)
```

## Spike Simulation

To work on Virtual machine, open terminal and type the below instructions:

 ``cd`` i.e., cd or change directory, the cd command allows you to move between directories. Download the leafpad for writing the c code. ``sudo apt install leafpad``.

 Type ``cd`` in new tab.

``leafpad one_to_n_sum.c`` after writing the code on leafpad save it with `file_name`, here I have taken ``leafpad one_to_n_sum.c``.
![Day1_c_code_one_to_n_sum](https://github.com/user-attachments/assets/64a357d1-8844-4dcd-ac22-0d11a3810b87)

Provide ``gcc leafpad one_to_n_sum.c``. Write ``ls -ltr``, which is used in Unix/Linux terminals to list files and directories with specific options.
To view the output use the command ``./a.out``

![Day1_one_to_n_sum_output](https://github.com/user-attachments/assets/7e43ee2e-5118-4586-bbca-8ed074ba790e)

Then type `cat one_to_n_sum.c`. The cat command reads each File parameter in sequence and writes it to standard output.

Now, to compile it with RISCv, `riscv64-unknown-elf-gcc -o1 -mabi=lp64 -march=rv64i -o one_to_n_sum.o one_to_n_sum.c` then type `ls -ltr one_to_n_sum.c`
![Day1_to_compile_c_code_riscv](https://github.com/user-attachments/assets/dae519df-9cba-47c1-a398-c5980cfffe4d)

Lets type the command to get assembly code for the C code.
`ricv64-unknown-elf-objdump -d one_to_n_sum.o` then type `ricv64-unknown-elf-objdump -d one_to_n_sum.o | less`
This would open the main section of assembly code if not shown then type `/main` or/and press `n` in keypad

To check the number of instruction instead of manully counting.
Take the last instruction and subtract it with the 1st instruction then divide it by 4 to get the number of instruction.

Take a look at the below picture, lets calculate the number of instruction:
![Screenshot (945)](https://github.com/user-attachments/assets/545e10a4-f097-4ca5-b85c-1b1a63376f2e)
First let us add 1020c with 4 to see if the next instruction abtained is correct or not. So, as we see in the picture it is correct as it gives 10210
![Screenshot (947)](https://github.com/user-attachments/assets/84a5fe8f-ba5c-4e56-8d63-bbfda4b8bcc5)
Now, let us do the caculation.
Take the last instruction 10210 subtract it with the fiest instruction 10184 we are getting 8c then divide 8c with four we get 35 instructions.
i.e., ``` 10210-10184=8c ``` then ```8c/4=35 inst. ```


Now let us do the **Spike Simulation** to debug.

Type the command `ricv64-unknown-elf-gcc -o1 -mabi=lp64 -march=rv64i -o one_to_n_sum.o one_to_n_sum.c`. then do `spike pk one_to_n_sum.o` and then `spike -d pk one_to_n_sum.o`

And, to read the content of the register type `until pc 0 100b0` and `reg 0 a` at first it will give null as the content and after performing some operations it would give the desired the result. Same way to view the content of  stack pointer(sp), repeat the steps `until pc 0 100b8` and then `reg 0 sp`.

![Screenshot (950)](https://github.com/user-attachments/assets/23f5573b-49cf-48bf-956d-bd5e136b4858)

Similarly we can do for the `-ofast`, `ricv64-unknown-elf-gcc -ofast -mabi=lp64 -march=rv64i -o one_to_n_sum.o one_to_n_sum.c`, then repeat the stepas as above that is done for `-o1`
![Screenshot (952)](https://github.com/user-attachments/assets/f3630e7f-37a0-4d86-995e-c8a8bef8c41b)

## Double-word and single word

> Referred Chatgpt for some content


**Single Word**

- A **word** in a computer is just a group of bits (binary digits).
- A **single word** usually means **16 bits** or **32 bits**, depending on the computer.
- Computers use it to store numbers, letters, or instructions.

**Example**:
- A 32-bit single word can store a number like: `00000000 00000000 00000000 00000001`  
  → This is **1** in decimal.

---

**Double Word**

- A **double word** is **twice the size** of a single word.
- If a single word is 32 bits, a double word is **64 bits**.
- It can hold **bigger numbers** or more detailed data.

**Example**:
- A 64-bit double word: `00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000001`  
  → This is **1** in decimal, but you can store numbers up to **18 quintillion+**!

---

**Binary to Decimal Conversion (Easy Method)**

Binary numbers use only **0** and **1**. Here's how you can convert them to decimal:

**Steps**:
1. Write down the binary number.
2. Starting from the right, assign powers of 2 to each bit.
3. Multiply each bit by 2 raised to its position.
4. Add the results.

**Example**:
Let’s convert `1011` to decimal:

```
Binary:   1    0    1    1
Power:    2^3  2^2  2^1  2^0
Value:    8 +  0 +  2 +  1  = 11
```

 **Decimal = 11**


## Binary to Decimal Conversion – Signed and Unsigned (64-bit)

Binary numbers can be represented in two common forms in a 64-bit system:

1. **Unsigned Binary** – Only positive numbers and zero.
2. **Signed Binary (Two's Complement)** – Can represent both positive and negative numbers.

---

**1. Unsigned 64-bit Binary Numbers**

- All 64 bits are used to represent the value.
- The value is always **non-negative**.
- No bit is reserved for the sign.

**Range:**
- Minimum value = 0  
- Maximum value = 2⁶⁴ - 1 = 18,446,744,073,709,551,615

**Example 1:**
```
Binary: 00000000...00000001 (63 zeros followed by 1)
Decimal: 1
```

**Example 2:**
```
Binary: 11111111...11111111 (64 ones)
Decimal: 18,446,744,073,709,551,615
```

---

**2. Signed 64-bit Binary Numbers (Two's Complement)**

- The **most significant bit (MSB)** is used as the **sign bit**:
  - `0` → Positive number
  - `1` → Negative number
- Remaining 63 bits represent the magnitude.

**Range:**
- Minimum value = -2⁶³ = -9,223,372,036,854,775,808  
- Maximum value =  2⁶³ - 1 =  9,223,372,036,854,775,807

---

**How to Convert Signed Binary to Decimal**

**Case 1: MSB = 0 (Positive number)**

- Simply convert the binary number to decimal as usual.

**Example:**
```
Binary: 00000000...00000001
Decimal: 1
```

**Case 2: MSB = 1 (Negative number)**

Steps:
1. Invert all bits (change 0 to 1 and 1 to 0).
2. Add 1 to the result → This gives the **magnitude**.
3. Add a negative sign.

**Example:**
```
Binary: 11111111...11111111 (64 ones)

Step 1: Invert → 00000000...00000000
Step 2: Add 1 → 00000000...00000001
Step 3: Decimal value = -1
```

---

**Summary Table**

| Representation | Type        | Range                                      | Example (Binary)                     | Decimal Value          |
|----------------|-------------|--------------------------------------------|--------------------------------------|------------------------|
| Unsigned       | Positive     | 0 to 18,446,744,073,709,551,615            | 1111...1111 (64 bits)                | 18,446,744,073,709,551,615 |
| Signed         | Two's Complement | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 | 1111...1111 (64 bits)                | -1                     |
|                |             |                                            | 0000...0001 (64 bits)                | 1                      |

---

**In short**

64 bit is reffered as double word and 32 bit as word.
And to convert the binary number into decimal, we are going to add the 0's or 1's with respective places of 2^n. For example: 100110 it would be like, 1.2^0+0.2^1+0.2^2+1.2^3+1.2^4+0.2^5 .

To convert the positve binary into decimal eg 4 -> 100.

However, for negative numbers. -2 -> (2;s complement) 010 -> 101(invert the bits) -> add 1 -> we get 010
or else at 63rd do the multiplication by the bit x 2^(-63)

> For postive numbers MSB is 0
> For negative numbers MSB is 1
> For risv the positive doubleword numbers are written by `0 to 2^63-1` and negative doubleword as `-1 to 2^(-63)`.

Lets do the calculation in the virtual machine
