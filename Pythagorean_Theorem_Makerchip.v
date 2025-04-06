https://www.makerchip.com/sandbox/#

\m4_TLV_version 1d: tl-x.org
\SV
   `include "sqrt32.v";
   
   m5_makerchip_module
\TLV
   
   |calc
      ?$valid
         @1
            $a[7:0] = $rand1[3:0];
            $b[7:0] = $rand2[3:0];
            $aa[15:0] = $aa[7:0] ** 2;
            $bb[15:0] = $bb[7:0] ** 2;
         @2
            $cc[15:0] = $aa + $bb;
         @3
            $c[7:0] = sqrt($cc);


   // Print
   |calc
      @3
         \SV_plus
            always_ff @(posedge clk) begin
               if ($valid)
                  \$display("sqrt((\%2d ^ 2) + (\%2d ^ 2)) = \%2d", $aa, $bb, $cc);
            end

\SV
   endmodule
