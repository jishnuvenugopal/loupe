
module TopModule (
    input clk,
    input d,
    input q
);
    reg [0:0] dff;

    always @(posedge clk) begin
        dff <= d;
    end

    assign out = dff;
endmodule
