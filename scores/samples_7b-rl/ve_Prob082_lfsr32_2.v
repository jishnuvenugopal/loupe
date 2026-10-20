
module TopModule (
    input clk,
    input reset,
    output [31:0] q
);
    reg [31:0] lfsr;
    wire feedback;
    
    
    assign feedback = lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0];

    always @(posedge clk) begin
        if (reset)
            lfsr <= 32'h1;
 
        else
            
            lfsr <= {lfsr[30:0], feedback} ^ (feedback ? 32'h82000005 : 0);
    end

    assign q = lfsr;
endmodule
