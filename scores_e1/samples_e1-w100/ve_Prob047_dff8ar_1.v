
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs [0:7];

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            dffs <= 8'b00000000;
        end else begin
            
            dffs <= d;
        end
    end

    
    assign q = dffs;

endmodule
