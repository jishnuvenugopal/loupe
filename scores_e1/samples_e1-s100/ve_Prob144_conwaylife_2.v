
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    
    reg [15:0] grid [15:0];

    
    reg [255:0] gameState;

    
    always @(posedge clk) begin
        if (load) begin
            
            for (int i = 0;
 i < 16;
 i++) begin
                for (int j = 0;
 j < 16;
 j++) begin
                    grid[i][j] = data[i * 16 + j];
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
                            int ni = (i + di + 16) % 16;
                            int nj = (j + dj + 16) % 16;
                            count += grid[ni][nj];
                        end
                    end

                    
                    if (grid[i][j] == 0 && count == 1) begin
                        gameState[i * 16 + j] = 1;
                    end else if (grid[i][j] == 1 && (count == 2 || count == 3)) begin
                        gameState[i * 16 + j] = 1;
                    end else if (grid[i][j] == 1 && count == 4) begin
                        gameState[i * 16 + j] = 0;
                    end
                end
            end
        end
    end

    
    assign q = gameState;

endmodule
