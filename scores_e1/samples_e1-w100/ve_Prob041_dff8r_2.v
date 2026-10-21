
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dffs [0:7];

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            dffs <= 8'b0;
        end else begin
            
            dffs <= d;
        end
    end

    
    assign q = dffs;

endmodule
