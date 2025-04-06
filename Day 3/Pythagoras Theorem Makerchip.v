//=====Link of the project: www.makerchip.com/sandbox/0o2fXho92/0X6hXxw====//

//=================================================//
//=============Pythogoras Theorem==================//
//=================================================//


\m4_TLV_version 1d: tl-x.org
\SV
   `include "sqrt32.v";
   
   m4_makerchip_module

\TLV
   
   |calc
      @1
         $a[7:0] = $rand1[3:0];
         $b[7:0] = $rand2[3:0];
         $aa[15:0] = $aa[7:0] ** 2;
         $bb[15:0] = $bb[7:0] ** 2;
      @2
         $cc[15:0] = $aa + $bb;
      @3
         $c[7:0] = sqrt($cc);

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
