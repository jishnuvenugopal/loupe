
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);
    
    wire feedback;
    assign feedback = q[4] ^ q[2];
    
    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
 
        else
            q <= { (q[3] ^ feedback), q[2], q[1], q[0], feedback };
    end
endmodule
