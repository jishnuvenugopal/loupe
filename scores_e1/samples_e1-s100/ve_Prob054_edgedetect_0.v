
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (in == 8'b0) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 8'b0;
            pedge <= 1'b1;
        end
    end

endmodule
