
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    localparam NUM_DFFS = 16;

    
    reg [15:0] dffs[NUM_DFFS];

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            
            for (int i = 0;
 i < NUM_DFFS;
 i = i + 1) begin
                dffs[i] <= 16'b0;
            end
        end else begin
            
            for (int i = 0;
 i < NUM_DFFS;
 i = i + 1) begin
                if (byteena[1] == 1'b1) begin
                    
                    dffs[i][15:8] <= d[15:8];
                end
                if (byteena[0] == 1'b1) begin
                    
                    dffs[i][7:0] <= d[7:0];
                end
            end
        end
    end

    
    assign q = dffs[NUM_DFFS - 1];

endmodule
