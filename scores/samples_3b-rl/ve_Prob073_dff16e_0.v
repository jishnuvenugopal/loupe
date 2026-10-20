
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dff [15:0];

    integer i;

    always @(posedge clk) begin
        if (!resetn) begin
            
            for (i = 0;
 i < 16;
 i = i + 1) begin
                dff[i] <= 16'b0;
            end
        end else begin
            
            if (byteena[1]) begin
                
                dff[15] <= d[15:8];
            end
            if (byteena[0]) begin
                
                dff[15:8] <= d[15:8];
                dff[7:0] <= d[7:0];
            end
            
            if (!byteena[1] && !byteena[0]) begin
                dff <= d;
            end
        end
    end

    
    always @(*) begin
        q = dff;
    end

endmodule
