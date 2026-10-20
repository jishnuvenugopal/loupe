
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output reg [255:0] q
);
    parameter WIDTH = 16;
    parameter HEIGHT = 16;
    parameterGRID_SIZE = WIDTH * HEIGHT;

    wire [Grid_SIZE-1:0] neighbors;

    
    function [4:0] countAliveNeighbors;
        input [Grid_SIZE-1:0] grid;
        input [4:0] x, y;
        integer i, j;
        begin
            countAliveNeighbors = 0;
            for (i = -1;
 i <= 1;
 i++) begin
                for (j = -1;
 j <= 1;
 j++) begin
                    if (i == 0 && j == 0) continue;
                    integer nx = (x + i + WIDTH) % WIDTH;
                    integer ny = (y + j + HEIGHT) % HEIGHT;
                    countAliveNeighbors += grid[(ny * WIDTH) + nx];
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0;
 i < HEIGHT;
 i++) begin
                for (integer j = 0;
 j < WIDTH;
 j++) begin
                    integer index = (i * WIDTH) + j;
                    neighbors[index] = countAliveNeighbors(q, in, j);
                    if (q[index] == 1 && (neighbors[index] == 0 || neighbors[index] == 1)) begin
                        q[index] <= 0;
                    end else if (q[index] == 0 && neighbors[index] == 3) begin
                        q[index] <= 1;
                    end else begin
                        q[index] <= q[index];
                    end
                end
            end
        end
    end
endmodule
