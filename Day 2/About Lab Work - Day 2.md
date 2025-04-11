# Day 2


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
