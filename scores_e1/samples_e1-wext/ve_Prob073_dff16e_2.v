
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dffs [0:15];

    
    always @(posedge clk) begin
        if (!resetn) begin
            
            for (int i = 0;
 i < 16;
 i = i + 1) begin
                dffs[i] <= 16'b0;
            end
        end else begin
            
            for (int i = 0;
 i < 16;
 i = i + 1) begin
                if (byteena[1] == 1'b1) begin
                    dffs[i] <= d[15:8];
                end
                if (byteena[0] == 1'b1) begin
                    dffs[i] <= d[7:0];
                end
            end
        end
    end

    
    assign q = dffs[0];

endmodule
