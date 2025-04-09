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
