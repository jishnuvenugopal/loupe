
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs [0:7];

    
    assign dffs[0] = d[0];
    assign dffs[1] = d[1];
    assign dffs[2] = d[2];
    assign dffs[3] = d[3];
    assign dffs[4] = d[4];
    assign dffs[5] = d[5];
    assign dffs[6] = d[6];
    assign dffs[7] = d[7];

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            dffs[i] <= d[i];
        end
    end

    
    always @(posedge reset) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            dffs[i] <= 8'b0;
        end
    end

    
    assign q = dffs[0];

endmodule
