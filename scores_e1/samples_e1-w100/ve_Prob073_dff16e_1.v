
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    localparam NUM_DFFS = 16;

    
    reg [15:0] dffs[NUM_DFFS];

    
    reg clk_en;

    
    reg reset;

    
    initial begin
        reset = 1'b1;
        clk_en = 1'b0;
    end

    
    always @(posedge resetn or posedge clk) begin
        if (resetn) begin
            reset = 1'b1;
            clk_en = 1'b0;
        end else begin
            reset = 1'b0;
            clk_en = 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (clk_en) begin
            for (int i = 0;
 i < NUM_DFFS;
 i++) begin
                if (byteena[1] == 1'b1 && i < 8) begin
                    dffs[i] <= d[15-i:8];
                end else if (byteena[0] == 1'b1 && i >= 8) begin
                    dffs[i] <= d[7-i:0];
                end else begin
                    dffs[i] <= dffs[i];
                end
            end
        end
    end

    
    assign q = dffs;

endmodule
