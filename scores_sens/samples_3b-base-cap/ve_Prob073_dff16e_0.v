
module TopModule (
    input  clk,
    input  resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);


reg [15:0] regfile [0:15];


always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        for (int i = 0;
 i < 16;
 i++) begin
            regfile[i] <= 16'h0;
        end
    end
end


always @(posedge clk) begin
    if (byteena[0]) begin
        regfile[0] <= d[7:0];
    end
    if (byteena[1]) begin
        regfile[8] <= d[15:8];
    end
end


assign q = regfile;

endmodule
