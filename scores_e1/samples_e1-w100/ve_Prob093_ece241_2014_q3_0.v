
     module TopModule (
         input wire c,
         input wire d,
         output reg [3:0] mux_in
     );
         wire [1:0] ab;
         wire [1:0] ab2;
         wire [1:0] ab3;

         
         mux2_1 abmux (
             .a(a),
             .b(b),
             .s(ab[0]),
             .y(ab)
         );

         
         mux2_1 abmux2 (
             .a(ab[1]),
             .b(b),
             .s(ab2[0]),
             .y(ab2)
         );

         
         mux2_1 abmux3 (
             .a(ab[1]),
             .b(ab[0]),
             .s(ab3[0]),
             .y(ab3)
         );

         
         mux4_1 mux4 (
             .a(c),
             .b(d),
             .c(ab3[1]),
             .d(ab2[1]),
             .mux_in(mux_in)
         );
     endmodule
     