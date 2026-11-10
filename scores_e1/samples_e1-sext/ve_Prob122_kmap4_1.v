
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [3:0] state;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 4'b0000;
            out <= 1'b0;
        end else begin
            state <= {state[2:0], a, b, c};
            out <= state[3];
        end
    end

endmodule
