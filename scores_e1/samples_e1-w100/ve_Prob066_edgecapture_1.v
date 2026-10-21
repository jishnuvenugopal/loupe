
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    
    reg [31:0] ff;

    
    always @(posedge clk) begin
        if (reset) begin
            ff <= 32'b0;
 
        end else if (in != ff) begin
            ff <= in;
 
        end
    end

    
    assign out = ff;

endmodule
