\m4_TLV_version 1d: tl-x.org

//============================================================//
//              Pythagoras Theorem 3 Dimensional              //
//============================================================//
\SV
   `include "sqrt32.v";
   m4_makerchip_module
\TLV

   |calc
      
      // DUT
      /coord[1:0]
         @1
            $sq[9:0] = $value[3:0] ** 2;
      @2
         $cc_sq[10:0] = /coord[0]$sq + /coord[1]$sq;
      @3
         $cc[4:0] = sqrt($cc_sq);


      // Print
      @3
         \SV_plus
            always_ff @(posedge clk) begin
               \$display("sqrt((\%2d ^ 2) + (\%2d ^ 2)) = %2d", /coord[0]$value, /coord[1]$value, $cc);
            end

\SV
endmodule
