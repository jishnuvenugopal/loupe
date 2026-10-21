
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    
    reg [15:0] grid [15:0];
    reg [15:0] alive_neighbors [15:0];

    
    initial begin
        for (int i = 0;
 i < 16;
 i++) begin
            for (int j = 0;
 j < 16;
 j++) begin
                grid[i][j] = 0;
                alive_neighbors[i][j] = 0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (load) begin
            for (int i = 0;
 i < 16;
 i++) begin
                for (int j = 0;
 j < 16;
 j++) begin
                    grid[i][j] = data[16*i + j];
                end
            end
        end else begin
            for (int i = 0;
 i < 16;
 i++) begin
                for (int j = 0;
 j < 16;
 j++) begin
                    
                    int count = 0;
                    for (int di = -1;
 di <= 1;
 di++) begin
                        for (int dj = -1;
 dj <= 1;
 dj++) begin
                            if (di == 0 && dj == 0) continue;
                            int ni = i + di;
                            int nj = j + dj;
                            if (ni < 0) ni = 15;
                            if (ni > 15) ni = 0;
                            if (nj < 0) nj = 15;
                            if (nj > 15) nj = 0;
                            count += grid[ni][nj];
                        end
                    end
                    
                    if (grid[i][j] == 1) begin
                        if (count < 2 || count > 3) grid[i][j] = 0;
                    end else begin
                        if (count == 3) grid[i][j] = 1;
                    end
                end
            end
        end
    end

    
    assign q = grid;

endmodule
