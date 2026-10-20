
module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

reg [31:0] previous_input;
reg [31:0] output_vec;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        output_vec <= 0;
        previous_input <= 0;
    end else begin
        previous_input <= in;
        output_vec <= previous_input & ~in;
    end
end

assign out = output_vec;

endmodule
