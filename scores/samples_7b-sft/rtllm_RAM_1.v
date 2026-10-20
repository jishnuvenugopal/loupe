
module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [WIDTH-1:0] RAM [0:DEPTH-1];


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        integer i;
        for (i = 0;
 i < DEPTH;
 i = i + 1)
            RAM[i] <= {WIDTH{1'b0}};
    end
    else if (write_en)
        RAM[write_addr] <= write_data;
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        read_data <= {WIDTH{1'b0}};
    else if (read_en)
        read_data <= RAM[read_addr];
    else
        read_data <= {WIDTH{1'b0}};
end

endmodule
