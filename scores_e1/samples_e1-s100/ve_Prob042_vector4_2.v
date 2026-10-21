
module SignExtender (
    input  [7:0] in,
    output [31:0] out
);

    wire [7:0] sign;
    wire [23:0] extended;

    
    assign sign = in[7];

    
    for (int i = 0;
 i < 24;
 i++) begin
        extended = extended << 1;
        extended = extended | sign;
    end

    
    assign out = extended;

endmodule
