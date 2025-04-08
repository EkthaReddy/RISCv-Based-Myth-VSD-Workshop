\m5_TLV_version 1d: tl-x.org
\m5

   // ====================================================//
   //     Pipelined Sequential Calculator With Counter    //
   // ====================================================//
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   
   |calc
      @1
         $val1[31:0] = $rand1[3:0];
         $val2[31:0] = >>2$out[31:0];
         
         $add[31:0] = $val1 + $val2;
         $sub[31:0] = $val1 - $val2;
         $mul[31:0] = $val1 * $val2;
         $div[31:0] = $val1 / $val2;
         
         $s[1:0] = $rand3[1:0];
         
         $count = 1 + >>1$count;
         $reset = *reset;
         $continue = 1'b1;
         
      @2
         $reset2 = ~$count | $reset; 
         $out[31:0] = $reset2 ? 32'h0000_0000 : $continue ? ($s[0] ? ($s[1] ? $div : $sub) : ($s[1] ? $mul : $add)) : >>1$out[31:0];

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
