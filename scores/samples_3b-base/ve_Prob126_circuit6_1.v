
module TopModule (
    input  [2:0] a,  
    output [15:0] q   
);

    
    localparam [15:0] q0 = 1232;
    localparam [15:0] q1 = 16#AEE0;
    localparam [15:0] q2 = 16#27D4;
    localparam [15:0] q3 = 16#5A0E;
    localparam [15:0] q4 = 16#2066;
    localparam [15:0] q5 = 16#64CE;
    localparam [15:0] q6 = 16#C526;
    localparam [15:0] q7 = 16#2F19;

    
    assign q = {q7, q6, q5, q4, q3, q2, q1, q0} [a];

endmodule
