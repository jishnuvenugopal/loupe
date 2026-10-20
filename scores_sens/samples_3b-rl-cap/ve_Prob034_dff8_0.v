
module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    always @(posedge clk) begin
        dff0 <= d[0];
        dff1 <= d[1];
        dff2 <= d[2];
        dff3 <= d[3];
        dff4 <= d[4];
        dff5 <= d[5];
        dff6 <= d[6];
        dff7 <= d[7];
    end

    assign q = {dff7, dff6, dff5, dff4, dff3, dff2, dff1, dff0};

endmodule
