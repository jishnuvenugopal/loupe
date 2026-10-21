
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    reg [15:0] dffs [0:15];

    
    assign dffs[0] = d[15:8];
    assign dffs[1] = d[7:0];
    assign dffs[2] = d[15:8];
    assign dffs[3] = d[7:0];
    assign dffs[4] = d[15:8];
    assign dffs[5] = d[7:0];
    assign dffs[6] = d[15:8];
    assign dffs[7] = d[7:0];
    assign dffs[8] = d[15:8];
    assign dffs[9] = d[7:0];
    assign dffs[10] = d[15:8];
    assign dffs[11] = d[7:0];
    assign dffs[12] = d[15:8];
    assign dffs[13] = d[7:0];
    assign dffs[14] = d[15:8];
    assign dffs[15] = d[7:0];

    
    always @(posedge clk) begin
        if (!resetn) begin
            
            dffs <= 16'b0;
        end else begin
            
            dffs[0] <= d[15:8] & byteena[1];
            dffs[1] <= d[7:0] & byteena[0];
            dffs[2] <= d[15:8] & byteena[1];
            dffs[3] <= d[7:0] & byteena[0];
            dffs[4] <= d[15:8] & byteena[1];
            dffs[5] <= d[7:0] & byteena[0];
            dffs[6] <= d[15:8] & byteena[1];
            dffs[7] <= d[7:0] & byteena[0];
            dffs[8] <= d[15:8] & byteena[1];
            dffs[9] <= d[7:0] & byteena[0];
            dffs[10] <= d[15:8] & byteena[1];
            dffs[11] <= d[7:0] & byteena[0];
            dffs[12] <= d[15:8] & byteena[1];
            dffs[13] <= d[7:0] & byteena[0];
            dffs[14] <= d[15:8] & byteena[1];
            dffs[15] <= d[7:0] & byteena[0];
        end
    end

    
    assign q = dffs;

endmodule
