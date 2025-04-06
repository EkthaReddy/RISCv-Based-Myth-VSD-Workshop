//====Link: www.makerchip.com/sandbox/0o2fXho92/0Y6hLzn===//

\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================//
   //            Fibonacci Sequence Generator          //
   // =================================================//
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   $num[31:0] = $reset ? 0 : (>>1$num + 1);
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
