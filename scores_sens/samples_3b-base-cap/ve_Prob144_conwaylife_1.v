
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    localparam GRID_SIZE = 16;
    localparam GRID_WIDTH = $clog2(GRID_SIZE);
    localparam GRID_HEIGHT = GRID_SIZE;
    localparam GRID_SIZE_BITS = $clog2(GRID_SIZE * GRID_SIZE);

    
    localparam NEIGHBOURS = 8;

    
    reg [GRID_SIZE-1:0] grid [GRID_SIZE-1:0];

    
    function int countAliveNeighbours(int x, int y);
        int count = 0;
        for (int dx = -1;
 dx <= 1;
 dx++) {
            for (int dy = -1;
 dy <= 1;
 dy++) {
                if (dx == 0 && dy == 0) continue;
 
                int nx = (x + dx + GRID_SIZE) % GRID_SIZE;
                int ny = (y + dy + GRID_SIZE) % GRID_SIZE;
                count += grid[nx][ny];
            }
        }
        return count;
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            
            for (int i = 0;
 i < GRID_SIZE;
 i++) begin
                for (int j = 0;
 j < GRID_SIZE;
 j++) begin
                    grid[i][j] = data[(i * GRID_SIZE + j) * 2 + 1];
                end
            end
        end else begin
            
            for (int i = 0;
 i < GRID_SIZE;
 i++) begin
                for (int j = 0;
 j < GRID_SIZE;
 j++) begin
                    int aliveNeighbours = countAliveNeighbours(i, j);
                    if (aliveNeighbours == 3) begin
                        q[(i * GRID_SIZE + j) * 2 + 1] = 1;
                    end else if (aliveNeighbours == 2) begin
                        q[(i * GRID_SIZE + j) * 2 + 1] = grid[i][j];
                    } else begin
                        q[(i * GRID_SIZE + j) * 2 + 1] = 0;
                    end
                end
            end
        end
    end

endmodule
