
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    
    localparam GRID_SIZE = 16;
    localparam GRID_WIDTH = $clog2(GRID_SIZE);
    localparam GRID_HEIGHT = $clog2(GRID_SIZE);
    localparam GRID_LENGTH = GRID_WIDTH * GRID_HEIGHT;

    
    localparam NEIGHBOURS = 8;

    
    typedef enum {DEAD, ALIVE} CellState;

    
    reg [GRID_WIDTH-1:0] grid [GRID_HEIGHT-1:0];

    
    function int countAliveNeighbours(int x, int y);
        int count = 0;
        for (int dx = -1;
 dx <= 1;
 dx++) {
            for (int dy = -1;
 dy <= 1;
 dy++) {
                if (dx == 0 && dy == 0) continue;
 
                int nx = (x + dx + GRID_WIDTH) % GRID_WIDTH;
                int ny = (y + dy + GRID_HEIGHT) % GRID_HEIGHT;
                count += grid[ny][nx];
            }
        }
        return count;
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            
            for (int i = 0;
 i < GRID_LENGTH;
 i++) begin
                grid[i / GRID_WIDTH][i % GRID_WIDTH] = data[i];
            end
        end else begin
            
            for (int i = 0;
 i < GRID_LENGTH;
 i++) begin
                int x = i / GRID_WIDTH;
                int y = i % GRID_WIDTH;
                int aliveNeighbours = countAliveNeighbours(x, y);
                if (grid[y][x] == ALIVE) begin
                    if (aliveNeighbours < 2 || aliveNeighbours > 3) begin
                        q[i] = DEAD;
                    end else begin
                        q[i] = ALIVE;
                    end
                end else begin
                    if (aliveNeighbours == 3) begin
                        q[i] = ALIVE;
                    end else begin
                        q[i] = DEAD;
                    end
                end
            end
        end
    end

endmodule
