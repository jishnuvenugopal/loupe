
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs [7:0];

    
    assign dffs = d;

    
    always @(posedge clk) begin
        if (areset) begin
            
            dffs <= 8'b0;
        end else begin
            
            dffs <= dffs;
        end
    end

    
    assign q = dffs;

endmodule
