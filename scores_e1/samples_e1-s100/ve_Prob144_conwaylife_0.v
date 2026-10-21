
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    
    reg [255:0] q;

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
    end

    
    function [7:0] count_neighbors(int i, int j);
        int x, y;
        int count = 0;

        
        for (x = -1;
 x <= 1;
 x++) begin
            for (y = -1;
 y <= 1;
 y++) begin
                if (x == 0 && y == 0) continue;
 
                int ni = i + x;
                int nj = j + y;
                if (ni >= 0 && ni < 16 && nj >= 0 && nj < 16) begin
                    count += q[ni * 16 + nj];
                end
            end
        end

        count_neighbors = count;
    endfunction

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 16;
 i++) begin
            for (int j = 0;
 j < 16;
 j++) begin
                int ni = i;
                int nj = j;
                if (ni >= 0 && ni < 16 && nj >= 0 && nj < 16) begin
                    int count = count_neighbors(ni, nj);
                    if (q[ni * 16 + nj] == 1) begin
                        if (count == 0 || count == 4) begin
                            q[ni * 16 + nj] = 0;
                        end
                    end else if (count == 3) begin
                        q[ni * 16 + nj] = 1;
                    end
                end
            end
        end
    end

endmodule
