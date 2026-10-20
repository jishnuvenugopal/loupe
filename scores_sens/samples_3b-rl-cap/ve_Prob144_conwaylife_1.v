
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    
    reg [15:0] q_row [0:15];

    
    function [3:0] count_neighbors;
        input [3:0] i, j;
        integer ni, nj;
        begin
            count_neighbors = 0;
            for (ni = i-1;
 ni <= i+1;
 ni = ni + 1)
                for (nj = j-1;
 nj <= j+1;
 nj = nj + 1)
                    
                    count_neighbors = count_neighbors + q_row[(ni+16) % 16][(nj+16) % 16];
            
            count_neighbors = count_neighbors - q_row[i][j];
        end
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            
            q <= data;
            for (integer i = 0;
 i < 16;
 i = i + 1)
                q_row[i] <= data[15*i +: 16];
        end else begin
            
            for (integer i = 0;
 i < 16;
 i = i + 1) begin
                for (integer j = 0;
 j < 16;
 j = j + 1) begin
                    
                    integer neighbors = count_neighbors(i, j);
                    
                    if (neighbors == 3)
                        q_row[i][j] = 1;
                    else if (neighbors == 2)
                        q_row[i][j] = q_row[i][j];
                    else
                        q_row[i][j] = 0;
                end
            end
            
            q = {q_row[15], q_row[14], q_row[13], q_row[12], q_row[11], q_row[10], q_row[9], q_row[8], q_row[7], q_row[6], q_row[5], q_row[4], q_row[3], q_row[2], q_row[1], q_row[0]};
        end
    end

endmodule
