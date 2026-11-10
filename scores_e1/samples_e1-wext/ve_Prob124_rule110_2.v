
module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

    
    reg [511:0] state;

    
    initial begin
        state = data;
    end

    
    always @(posedge clk) begin
        if (load) begin
            state = data;
        end else begin
            
            state[0] = (state[4] & state[5]) | (state[3] & state[4]);
            state[1] = (state[0] & state[1]) | (state[1] & state[2]);
            state[2] = (state[1] & state[2]) | (state[2] & state[3]);
            state[3] = (state[2] & state[3]) | (state[3] & state[4]);
            state[4] = (state[3] & state[4]) | (state[4] & state[5]);
            state[5] = (state[4] & state[5]) | (state[5] & state[0]);
        end
    end

    
    assign q = state;

endmodule
