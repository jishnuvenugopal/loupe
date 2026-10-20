
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            dff0 <= 8'b0;
            dff1 <= 8'b0;
            dff2 <= 8'b0;
            dff3 <= 8'b0;
            dff4 <= 8'b0;
            dff5 <= 8'b0;
            dff6 <= 8'b0;
            dff7 <= 8'b0;
        end else begin
            
            dff0 <= d[0];
            dff1 <= dff0;
            dff2 <= dff1;
            dff3 <= dff2;
            dff4 <= dff3;
            dff5 <= dff4;
            dff6 <= dff5;
            dff7 <= dff6;
        end
    end

    
    assign q = dff7;

endmodule
