
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] initial_state = {256{1'b0}};
 

    
    reg [255:0] game_state;

    
    function int count_alive_neighbors(int row, int col);
        int count = 0;
        for (int i = -1;
 i <= 1;
 i++) begin
            for (int j = -1;
 j <= 1;
 j++) begin
                if (i == 0 && j == 0) continue;
 
                int new_row = (row + i + 16) % 16;
                int new_col = (col + j + 16) % 16;
                count += game_state[new_row * 16 + new_col];
            end
        end
        count_alive_neighbors = count;
    endfunction

    
    always @(posedge clk) begin
        if (load) begin
            game_state = data;
        end else begin
            for (int row = 0;
 row < 16;
 row++) begin
                for (int col = 0;
 col < 16;
 col++) begin
                    int alive_neighbors = count_alive_neighbors(row, col);
                    if (game_state[row * 16 + col] == 1) begin
                        if (alive_neighbors == 0 || alive_neighbors == 4) begin
                            game_state[row * 16 + col] = 0;
                        end
                    end else begin
                        if (alive_neighbors == 3) begin
                            game_state[row * 16 + col] = 1;
                        end
                    end
                end
            end
        end
    end

    
    assign q = game_state;

endmodule
