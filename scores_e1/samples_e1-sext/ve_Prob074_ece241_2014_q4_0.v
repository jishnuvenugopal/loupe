
module TopModule (
    input clk,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] flip_flops [0:2];

always @(posedge clk) begin
    case (state)
        2'b00: begin
            flip_flops[0] <= x;
            state <= 2'b01;
        end
        2'b01: begin
            flip_flops[1] <= ~flip_flops[0];
            state <= 2'b10;
        end
        2'b10: begin
            flip_flops[2] <= ~flip_flops[1];
            state <= 2'b00;
            z <= ~flip_flops[0] & ~flip_flops[1] & ~flip_flops[2];
        end
    endcase
end

endmodule
