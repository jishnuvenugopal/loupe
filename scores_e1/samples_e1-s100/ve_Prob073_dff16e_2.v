
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    reg [15:0] dffs[15:0];

    
    assign dffs[0] = d[15:8];
    assign dffs[1] = d[13:6];
    assign dffs[2] = d[11:4];
    assign dffs[3] = d[9:2];
    assign dffs[4] = d[7:0];
    assign dffs[5] = d[5:0];
    assign dffs[6] = d[3:0];
    assign dffs[7] = d[1:0];
    assign dffs[8] = d[9:2];
    assign dffs[9] = d[7:0];
    assign dffs[10] = d[5:0];
    assign dffs[11] = d[3:0];
    assign dffs[12] = d[1:0];
    assign dffs[13] = d[9:2];
    assign dffs[14] = d[7:0];
    assign dffs[15] = d[5:0];

    
    assign q = dffs[0];

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            for (int i = 0;
 i < 16;
 i++) begin
                dffs[i] <= 16'b0;
            end
        end else begin
            for (int i = 0;
 i < 16;
 i++) begin
                if (byteena[i] == 1) begin
                    dffs[i] <= d[i];
                end
            end
        end
    end

endmodule
