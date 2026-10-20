
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    
    reg [3:0] d_ff0, d_ff1, d_ff2, d_ff3;

    
    always @(posedge reset) begin
        d_ff0 <= 4'b0;
        d_ff1 <= 4'b0;
        d_ff2 <= 4'b0;
        d_ff3 <= 4'b0;
    end

    
    always @(posedge clk) begin
        
        d_ff3 <= d_ff2;
        d_ff2 <= d_ff1;
        d_ff1 <= d_ff0;

        
        if (d_ff0 == 4'b0111) begin
            d_ff0 <= 4'b0000;
 
        end else begin
            d_ff0 <= d_ff0 + 1'b1;
        end
    end

    
    assign q = d_ff0;

endmodule
