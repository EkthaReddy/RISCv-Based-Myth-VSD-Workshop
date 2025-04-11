# Day 2


`leafpad 1to9_custom.c`

`leafpad load.S`

`cat 1to9_custom.c`

`cat load.S`

`riscv64-unknown-elf-gcc -ofast -mabi=lp64 -march=rv64i -o 1to9_custom.o 1to9_custom.c load.S`

`spike pk 1to9_custom.o`

`riscv64-unknown-elf-objdump -d 1to9_custom.o | less`

