
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    
    

    
    function [3:0] count_neighbors;
        input [3:0] i, j;
        integer k, l;
        begin
            count_neighbors = 0;
            
            for (k = -1;
 k <= 1;
 k = k + 1)
                for (l = -1;
 l <= 1;
 l = l + 1)
                    if (k != 0 || l != 0)
                        
                        count_neighbors = count_neighbors + q[(i + k + 16) % 16 + (j + l + 16) % 16];
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            
            reg [255:0] new_q;
            integer i, j;
            begin
                new_q = 0;
                for (i = 0;
 i < 16;
 i = i + 1)
                    for (j = 0;
 j < 16;
 j = j + 1) begin
                        
                        integer neighbors = count_neighbors(i, j);
                        
                        if (neighbors == 3)
                            new_q[i*16 + j] = 1;
                        else if (neighbors == 2)
                            new_q[i*16 + j] = q[i*16 + j];
                        else
                            new_q[i*16 + j] = 0;
                    end
            end
            q <= new_q;
        end
    end

endmodule
