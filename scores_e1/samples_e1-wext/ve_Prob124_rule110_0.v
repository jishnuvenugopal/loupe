
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    
    reg [511:0] state;

    
    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= state[510:0] ^ state[511] ^ state[0];
        end
    end

    
    assign q = state;

endmodule
