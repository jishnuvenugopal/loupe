
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    
    function [3:0] count_neighbours;
        input [255:0] grid;
        input [3:0] row_idx;
        input [3:0] col_idx;
        begin
            reg [3:0] count = 0;
            for (integer i = -1;
 i <= 1;
 i++) begin
                integer new_row = (row_idx + i) % 16;
                if (new_row < 0) new_row += 16;
                for (integer j = -1;
 j <= 1;
 j++) begin
                    integer new_col = (col_idx + j) % 16;
                    if (new_col < 0) new_col += 16;
                    if (i != 0 || j != 0) begin
                        count += grid[(new_row * 16) + new_col];
                    end
                end
            end
            count_neighbours = count;
        end
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0;
 i < 16;
 i++) begin
                for (integer j = 0;
 j < 16;
 j++) begin
                    integer idx = (i * 16) + j;
                    integer neighbour_count = count_neighbours(q, i, j);
                    if (q[idx] == 0) begin
                        if (neighbour_count == 3) begin
                            next_q[idx] <= 1;
                        end else begin
                            next_q[idx] <= 0;
                        end
                    end else begin
                        if (neighbour_count == 2 || neighbour_count == 3) begin
                            next_q[idx] <= 1;
                        end else begin
                            next_q[idx] <= 0;
                        end
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule
