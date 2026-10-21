
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (in == 0) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            pedge <= 1;
        end
    end

endmodule
