
module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    
    reg [1:0] ff_state;

    
    always @(posedge clk) begin
        if (b == 1) begin
            ff_state <= {ff_state[0], a};
        end else begin
            ff_state <= ff_state;
        end
        q <= ff_state[0];
        state <= ff_state[1];
    end

endmodule
