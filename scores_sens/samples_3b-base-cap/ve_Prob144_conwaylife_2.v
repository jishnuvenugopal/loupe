
module TopModule (
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    
    localparam GRID_SIZE = 16;
    localparam GRID_WIDTH = 16;
    localparam GRID_HEIGHT = GRID_SIZE * GRID_WIDTH;

    
    localparam NEIGHBOURS = 8;

    
    reg [GRID_WIDTH-1:0] current_state [GRID_HEIGHT-1:0];

    
    reg [GRID_WIDTH-1:0] next_state [GRID_HEIGHT-1:0];

    
    function int count_neighbours(int x, int y);
        int count = 0;
        for (int dx = -1;
 dx <= 1;
 dx++) {
            for (int dy = -1;
 dy <= 1;
 dy++) {
                int nx = (x + dx + GRID_WIDTH) % GRID_WIDTH;
                int ny = (y + dy + GRID_HEIGHT) % GRID_HEIGHT;
                count += current_state[ny][nx];
            }
        }
        count -= current_state[y][x];
 
        return count;
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            
            for (int i = 0;
 i < GRID_HEIGHT;
 i++) begin
                for (int j = 0;
 j < GRID_WIDTH;
 j++) begin
                    current_state[i][j] = data[i * GRID_WIDTH + j];
                end
            end
        end else begin
            
            for (int i = 0;
 i < GRID_HEIGHT;
 i++) begin
                for (int j = 0;
 j < GRID_WIDTH;
 j++) begin
                    int neighbours = count_neighbours(i, j);
                    if (neighbours == 3) begin
                        next_state[i][j] = 1;
 
                    } else if (neighbours == 2) begin
                        next_state[i][j] = current_state[i][j];
 
                    } else begin
                        next_state[i][j] = 0;
 
                    end
                end
            end
            
            for (int i = 0;
 i < GRID_HEIGHT;
 i++) begin
                for (int j = 0;
 j < GRID_WIDTH;
 j++) begin
                    current_state[i][j] = next_state[i][j];
                end
            end
        end
    end

    
    assign q = {current_state[GRID_HEIGHT-1][GRID_WIDTH-1], current_state[GRID_HEIGHT-1][GRID_WIDTH-2], ... , current_state[0][0]};

endmodule
