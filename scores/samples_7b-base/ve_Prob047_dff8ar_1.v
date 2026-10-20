
module TopModule (
    input  clk,
    input  areset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dffs;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dffs <= 8'b0;
        end else begin
            dffs <= d;
        end
    end

    
    assign q = dffs;

endmodule
