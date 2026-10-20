
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    parameter rows = 16;
    parameter cols = 16;
    parameter total_cells = rows * cols;

    reg [rows-1:0][cols-1:0] grid;

    integer i, j, k, l, row, col, neighbor_count;

    function [3:0] wrap;
        input [3:0] idx;
        begin
            wrap = (idx + total_cells) % total_cells;
        end
    endfunction

    always @(posedge clk or posedge load) begin
        if (load) begin
            for (i = 0;
 i < total_cells;
 i = i + 1) begin
                grid[i >> 4][i % 16] <= data[i];
            end
        end else begin
            for (i = 0;
 i < rows;
 i = i + 1) begin
                for (j = 0;
 j < cols;
 j = j + 1) begin
                    neighbor_count = 0;
                    for (k = -1;
 k <= 1;
 k = k + 1) begin
                        for (l = -1;
 l <= 1;
 l = l + 1) begin
                            if (k == 0 && l == 0) begin
                                continue;
                            end
                            row = (i + k + rows) % rows;
                            col = (j + l + cols) % cols;
                            neighbor_count = neighbor_count + grid[row][col];
                        end
                    end
                    if (neighbor_count == 0 || neighbor_count == 1) begin
                        grid[i][j] <= 0;
                    end else if (neighbor_count == 2) begin
                        
                    end else if (neighbor_count == 3) begin
                        grid[i][j] <= 1;
                    end else begin
                        grid[i][j] <= 0;
                    end
                end
            end
        end
    end

    always @(posedge clk) begin
        for (i = 0;
 i < total_cells;
 i = i + 1) begin
            q[i] <= grid[i >> 4][i % 16];
        end
    end

endmodule
