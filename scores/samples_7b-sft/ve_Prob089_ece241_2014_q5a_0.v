
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;
reg initial_phase;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b0;
        z <= 1'b0;
        initial_phase <= 1'b0;
    end else begin
        if (!initial_phase) begin
            
            carry <= 1'b1;
            z <= ~x ^ 1'b1;
            initial_phase <= 1'b1;
        end else begin
            z <= ~x ^ carry;
            carry <= (~x) & carry;
        end
    end
end

endmodule
