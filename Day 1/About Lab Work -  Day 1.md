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


