
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] grid;

    
    always @(posedge clk) begin
        if (load) begin
            grid <= data;
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 16;
 i++) begin
            for (int j = 0;
 j < 16;
 j++) begin
                
                int num_neighbors = 0;
                for (int di = -1;
 di <= 1;
 di++) begin
                    for (int dj = -1;
 dj <= 1;
 dj++) begin
                        if (di == 0 && dj == 0) continue;
                        int ni = (i + di + 16) % 16;
                        int nj = (j + dj + 16) % 16;
                        num_neighbors += grid[ni][nj];
                    end
                end

                
                if (num_neighbors == 0) begin
                    q[i][j] <= 0;
                end else if (num_neighbors == 2 || num_neighbors == 3) begin
                    q[i][j] <= grid[i][j];
                end else if (num_neighbors == 4) begin
                    q[i][j] <= 0;
                end
            end
        end
    end

endmodule
