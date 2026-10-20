
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [512:0] cells;

always @(posedge clk) begin
    if (load) begin
        cells[0] = data[0];
        cells[512] = data[511];
        for (integer i = 1;
 i < 512;
 i = i + 1) begin
            cells[i] = data[i-1];
        end
    end else begin
        for (integer i = 1;
 i < 512;
 i = i + 1) begin
            q[i-1] <= cells[i-1] ^ cells[i+1];
        end
    end
end

