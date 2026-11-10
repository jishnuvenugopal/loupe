
module TopModule (
    input wire clk,
    input wire resetn,
    input wire [1:0] byteena,
    input wire [15:0] d,
    output reg [15:0] q
);


reg [15:0] dffs [0:15];

always @(posedge clk or posedge resetn) begin
    if (resetn) begin
        
        for (int i = 0;
 i < 16;
 i = i + 1) begin
            dffs[i] <= 16'b0;
        end
    end else begin
        
        for (int i = 0;
 i < 16;
 i = i + 1) begin
            if (byteena[1] && i < 8) begin
                dffs[i] <= d[15:8];
            end else if (byteena[0] && i >= 8) begin
                dffs[i] <= d[7:0];
            end else begin
                dffs[i] <= dffs[i];
            end
        end
    end
end


assign q = dffs[0];

endmodule
