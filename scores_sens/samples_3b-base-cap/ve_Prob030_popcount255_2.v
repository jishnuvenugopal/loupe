
module TopModule (
    input [255:0] in,  
    output [7:0] out   
);

    
    reg [7:0] count;
  

    
    genvar i;
    generate
        for (i = 0;
 i < 255;
 i = i + 1) begin
            
            full_adder fa (
                .a(in[i]),
                .b(1'b0),  
                .cin(count[i]),
                .sum(count[i + 1]),
                .cout(count[i + 1])
            );
        end
    endgenerate

    
    assign out = count[7:0];

endmodule


module full_adder (
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);

    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
