
module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

    
    reg [511:0] state = {512{1'b0}};

    always @(posedge clk) begin
        if (load) begin
            state = data;
        end else begin
            
            state = state[510:0] ^ state[511] ^ state[0];
        end
    end

    
    assign q = state;

endmodule
