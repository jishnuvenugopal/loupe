
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] transition_count;
reg [7:0] current_state;
reg [7:0] next_state;

always @(posedge clk) begin
    current_state <= in;
    if (current_state == 8'b00000000 && next_state == 8'b00000001) begin
        transition_count <= transition_count + 1;
    end
end

always @(posedge transition_count) begin
    pedge <= current_state;
end

endmodule
