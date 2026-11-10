
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dffs[15:0];

    
    always @(posedge clk or posedge resetn) begin
        if (!resetn) begin
            
            dffs <= 16'b0;
        end else begin
            
            dffs[15:0] <= d;
            
            dffs[15:8] <= (byteena[1] == 1'b1) ? d[15:8] : dffs[15:8];
            dffs[7:0] <= (byteena[0] == 1'b1) ? d[7:0] : dffs[7:0];
        end
    end

    
    assign q = dffs;

endmodule
