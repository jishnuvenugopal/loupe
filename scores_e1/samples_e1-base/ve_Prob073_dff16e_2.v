
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
            
            if (byteena[1]) begin
                dffs[15:8] <= d[15:8];
            end
            if (byteena[0]) begin
                dffs[7:0] <= d[7:0];
            end
        end
    end

    
    assign q = dffs;

endmodule
