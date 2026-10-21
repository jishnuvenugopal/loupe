
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] state;
    reg [7:0] prev_state;

    always @(posedge clk) begin
        prev_state <= state;
        state <= in;

        if (state == 0 && prev_state == 1) begin
            pedge <= 1;
        end else begin
            pedge <= 0;
        end
    end

endmodule
