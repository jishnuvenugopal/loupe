
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg current_state;
localparam B = 1'b1;
localparam A = 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        case (current_state)
            B: current_state <= in ? B : A;
            A: current_state <= in ? A : B;
            default: current_state <= B;
        endcase
    end
end

assign out = current_state;

endmodule
