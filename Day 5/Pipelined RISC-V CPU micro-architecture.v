\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/BalaDhinesh/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV

   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program for MYTH Workshop to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum
   // 
   // External to function:
   m4_asm(ADD, r10, r0, r0)             // Initialize r10 (a0) to 0.
   // Function:
   m4_asm(ADD, r14, r10, r0)            // Initialize sum register a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store count of 10 in register a2.
   m4_asm(ADD, r13, r10, r0)            // Initialize intermediate sum register a3 with 0
   // Loop:
   m4_asm(ADD, r14, r13, r14)           // Incremental addition
   m4_asm(ADDI, r13, r13, 1)            // Increment intermediate register by 1
   m4_asm(BLT, r13, r12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   m4_asm(ADD, r10, r14, r0)            // Store final result to register a0 so that it can be read by main program
   m4_asm(SW, r0, r10, 100)
   m4_asm(LW, r15,r0, 100)
   
   // Optional:
   // m4_asm(JAL, r7, 00000000000000000000) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   |cpu
      @0
         //Program_counter
         $reset = *reset;
         
         $imem_rd_en = ~ $reset;
         
         $pc[31:0] = >>1$reset ? 0 :
                     >>3$valid_taken_br ? >>3$br_tgt_pc :
                     >>3$valid_load ? >>3$pc :
                     >>3$valid_jump && >>3$is_jal ?  >>3$br_tgt_pc :
                     >>3$valid_jump && >>3$is_jalr ? >>3$jalr_tgt_pc : 
                     >>1$pc + 32'd4;
         
         //if reset is active assign to zero
         // Or else, the branch taken 1 cycle ago should be activated for respective branch instruction
         // Or else the pc must be incremented by 4 instruction
         
         
         $imem_rd_addr[M4_IMEM_INDEX_CNT -1:0] = $pc[M4_IMEM_INDEX_CNT + 1:2];
         
      @1   
         $instr[31:0] = $imem_rd_data[31:0];
         
         //Decoder
         // For Instruction I
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
         
         //Immediate field of Decoder
         
         $imm[31:0] = $is_i_instr ? { {21{$instr[31]}}, $instr[30:20] } :
                      $is_s_instr ? { {21{$instr[31]}}, $instr[30:25], $instr[11:8], $instr[7]}:
                      $is_b_instr ? { {20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0} :
                      $is_u_instr ? { $instr[31], $instr[30:20], $instr[19:12], {12{1'b0}}} :
                      $is_j_instr ? { {12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:25], $instr[24:21], 1'b0}:
                      32'b0;
                      
         //Instruction Field Decode
         
         $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr;
         $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         $funct7_valid = $is_r_instr;
         $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         
         $opcode[6:0] = $instr[6:0];
         
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
         
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
         
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
            
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
            
         ?$rd_valid
            $rd[4:0] = $instr[11:7];
            
         //To decode individual instruction   
         $dec_bits[10:0] = {$funct7[5], $funct3, $opcode};
         
         $is_lui = $dec_bits ==? 11'bx_xxx_0110111;
         $is_auipc = $dec_bits ==? 11'bx_xxx_0010111;
         $is_jal = $dec_bits ==? 11'bx_xxx_1101111;
         $is_jalr = $dec_bits ==? 11'bx_000_1100111;
         
         $is_beq = $dec_bits ==? 11'bx_000_1100011;
         $is_bne = $dec_bits ==? 11'bx_001_1100011;
         $is_blt = $dec_bits ==? 11'bx_100_1100011;
         $is_bge = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         
         $is_lb = $dec_bits ==? 11'bx_000_0000011;
         $is_lh = $dec_bits ==? 11'bx_001_0000011;
         $is_lw = $dec_bits ==? 11'bx_010_0000011;
         $is_lbu = $dec_bits ==? 11'bx_100_0000011;
         $is_lhu = $dec_bits ==? 11'bx_101_0000011;
         $is_sb = $dec_bits ==? 11'bx_000_0100011;
         $is_sh = $dec_bits ==? 11'bx_001_0100011;
         $is_sw = $dec_bits ==? 11'bx_010_0100011;
         
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_slti = $dec_bits ==? 11'bx_010_0010011;
         $is_sltiu = $dec_bits ==? 11'bx_011_0010011;
         $is_xori = $dec_bits ==? 11'bx_100_0010011;
         $is_ori = $dec_bits ==? 11'bx_110_0010011;
         $is_andi = $dec_bits ==? 11'bx_111_0010011;
         $is_slli = $dec_bits ==? 11'b0_001_0010011;
         $is_srli = $dec_bits ==? 11'b0_101_0010011;
         $is_srai = $dec_bits ==? 11'b1_101_0010011;
      
         $is_add = $dec_bits ==? 11'b0_000_0110011;
         $is_sub = $dec_bits ==? 11'b1_000_0110011;
         $is_sll = $dec_bits ==? 11'b0_001_0110011;
         $is_slt = $dec_bits ==? 11'b0_010_0110011;
         $is_sltu = $dec_bits ==? 11'b0_011_0110011;
         $is_xor = $dec_bits ==? 11'b0_100_0110011;
         $is_srl = $dec_bits ==? 11'b0_101_0110011;
         $is_sra = $dec_bits ==? 11'b1_101_0110011;
         $is_or = $dec_bits ==? 11'b0_110_0110011;
         $is_and = $dec_bits ==? 11'b0_111_0110011;
         
         $is_load = $dec_bits ==? 11'bx_xxx_0000011;
         
         //Until the instrs are implemented, quiet down the warnings
         
         `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu
                    $is_lui $is_auipc $is_jal $is_jalr $is_lb $is_lh $is_lw $is_lbu $is_lhu $is_sb $is_sh $is_sw 
                    $is_addi $is_slti $is_sltiu $is_xori $is_ori $is_andi $is_slli $is_srli $is_srai
                    $is_add $is_sub $is_sll $is_slt $is_sltu $is_xor $is_srl $is_sra $is_or $is_and
                    $is_load);
      @2  
         //Read function of register file
         
         $rf_rd_en1 = $rs1_valid;
         $rf_rd_index1[4:0] = $rs1[4:0];
         
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index2[4:0] = $rs2[4:0];
         
         
         $src1_value[31:0] = ($rf_rd_index1 == >>1$rf_wr_index) ? 
                    ( >>1$rf_wr_en ? >>1$result[31:0] : $rf_rd_data1[31:0] )
                    : $rf_rd_data1[31:0];
         
         $src2_value[31:0] = ($rf_rd_index2 == >>1$rf_wr_index) ? 
                    ( >>1$rf_wr_en ? >>1$result[31:0] : $rf_rd_data2[31:0] )
                    : $rf_rd_data2[31:0];
         //If the read index and write index are same 
         //then the data that goes to mux1 can either be result of ALU or data 1 of read file
         //If read and write are not same
         //then directly the data1 goes to ALU src1
         // Similary for the src2 value.
         
         $br_tgt_pc[31:0] = $pc[31:0] +$imm[31:0];           
      @3   
         //ALU
         $result[31:0] = $is_addi ? $src1_value + $imm:
                         $is_add ? $src1_value + $src2_value:
                         $is_sub ? $src1_value - $src2_value:
                         $is_sll ? $src1_value << $src2_value[4:0]:
                         $is_srl ? $src1_value >> $src2_value[4:0]:
                         $is_sltu ? $src1_value < $src2_value:
                         $is_sltiu ? $src1_value <$imm:
                         
                         $is_andi ? $src1_value & $imm:
                         $is_ori ? $src1_value | $imm:
                         $is_xori ? $src1_value ^ $imm:
                         $is_slli ? $src1_value << $imm[5:0]:
                         $is_srli ? $src1_value >> $imm[5:0]:
                         $is_and ? $src1_value & $src2_value:
                         $is_or ? $src1_value | $src2_value:
                         $is_xor ? $src1_value ^ $src2_value:
                         
                         $is_load ? $src1_value + $imm :
                         $is_s_instr ? $src1_value + $imm :
                         
                         $is_auipc ? $pc + $imm:
                         $is_jal ? $pc + 4:
                         $is_jalr ? $pc + 4:
                         
                         $is_srai ? { {32{$src1_value[31]}}, $src1_value} >> $imm[4:0]:
                         $is_slt ? ($src1_value[31] == $src2_value[31]) ? ($src1_value < $src2_value) : {31'b0, $src1_value[31]}:
                         $is_slti ? ($src1_value[31] == $imm[31]) ? ($src1_value ^ $src2_value) : {31'b0, $src1_value[31]}:
                         $is_sra ? { {32{$src1_value[31]}}, $src1_value} >> $src2_value[4:0]:
                         32'bx;
           
         
         //Write Register File      
         $rf_wr_en = ($rd && $rd_valid && $valid) || >>2$valid_load;
         $rf_wr_index[4:0] = >>2$valid_load ? >>2$rd[4:0] : $rd[4:0];
         $rf_wr_data[31:0] = >>2$valid_load ? >>2$ld_data[31:0]: $result[31:0];
         
         // Branch Instructions
         $taken_br = $is_b_instr ?
                     ($is_beq ? ($src1_value == $src2_value):
                     $is_bne ? ($src1_value != $src2_value) :
                     $is_blt ? (($src1_value < $src2_value) ^($src1_value[31]!=$src2_value[31])):
                     $is_bge ? (($src1_value >= $src2_value) ^($src1_value[31]!=$src2_value[31])):
                     $is_bltu ? ($src1_value < $src2_value):
                     $is_bgeu ? ($src1_value >= $src2_value): 1'b0):
                     1'b0;
         
         
         //Valid Instructions 
         $valid_load = $valid && $is_load;
         
         $valid_jump = $valid && ($is_jal || $is_jalr );
         
         $valid_taken_br = $taken_br && $valid;
         
         $valid = !(>>1$taken_br || >>2$taken_br || 
                   >>1$valid_load || >>2$valid_load || 
                   >>1$valid_jump || >>2$valid_jump);
                   
         // Jump target 
         $jalr_tgt_pc[31:0] = $src1_value[31:0] + $imm[31:0];
         
      @4   
         //Data Memory
         $dmem_wr_en = $is_s_instr && $valid;
         $dmem_rd_en = $is_load;
         $dmem_addr[3:0] = $result[5:2];
         $dmem_wr_data[31:0] = $src2_value;
         
         
         
      @5
         $ld_data[31:0] = $dmem_rd_data[31:0];
         
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = |cpu/xreg[10]>>5$value == (1+2+3+4+5+6+7+8+9);
   *failed = 1'b0;
   
   // Macro instantiations for:
   //  o instruction memory
   //  o register file
   //  o data memory
   //  o CPU visualization
   |cpu
      m4+imem(@1)    // Args: (read stage)
      m4+rf(@2, @3)  // Args: (read stage, write stage) - if equal, no register bypass is required
      m4+dmem(@4)    // Args: (read/write stage)

   //m4+cpu_viz(@4)    // For visualisation, argument should be at least equal to the last stage of CPU logic. @4 would work for all labs.
\SV
   endmodule

                   
