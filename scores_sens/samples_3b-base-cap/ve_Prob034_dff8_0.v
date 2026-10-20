
module TopModule (
    input  clk,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    always @(posedge clk) begin
        dff0 <= d[0];
        dff1 <= dff0;
        dff2 <= dff1;
        dff3 <= dff2;
        dff4 <= dff3;
        dff5 <= dff4;
        dff6 <= dff5;
        dff7 <= dff6;
    end

    
    assign q = dff7;

endmodule
