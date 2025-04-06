\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // =============Combinational Calculator============
   // =================================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $val1[31:0] = $rand1[3:0];
   $val2[31:0] = $rand2[3:0];
   
   $sum[31:0] = $val1 + $val2;
   $diff[31:0] = $val1 - $val2;
   $mul[31:0] = $val1 * $val2;
   $div[31:0] = $val1 / $val2;
   
   $op[1:0] = $rand3[1:0];
   
   $output[31:0] = $op[0] ? ($op[1] ? $div : $diff):($op[1] ? $mul : $sum);
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule

Link: www.makerchip.com/sandbox/0o2fXho92/0RghvAz
