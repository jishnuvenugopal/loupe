
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    initial begin
        dff0 = 8'b110100;
        dff1 = 8'b110100;
        dff2 = 8'b110100;
        dff3 = 8'b110100;
        dff4 = 8'b110100;
        dff5 = 8'b110100;
        dff6 = 8'b110100;
        dff7 = 8'b110100;
    end

    
    always @(negedge clk) begin
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
            dff1 <= d[1];
            dff2 <= d[2];
            dff3 <= d[3];
            dff4 <= d[4];
            dff5 <= d[5];
            dff6 <= d[6];
            dff7 <= d[7];
        end
    end

    
    assign q = {dff7, dff6, dff5, dff4, dff3, dff2, dff1, dff0};

endmodule
