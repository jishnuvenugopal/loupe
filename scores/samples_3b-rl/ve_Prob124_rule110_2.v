
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [5:0] next_state;
        for (integer i = 0;
 i < 512;
 i = i + 1) begin
            case ({q[i-1], q[i], q[i+1]})
                3'b111: next_state = 1;
                3'b110: next_state = 1;
                3'b101: next_state = 1;
                3'b100: next_state = 0;
                3'b011: next_state = 1;
                3'b010: next_state = 1;
                3'b001: next_state = 1;
                3'b000: next_state = 0;
                default: next_state = 0;
            endcase
            q[i] <= next_state;
        end
    end
end

endmodule
