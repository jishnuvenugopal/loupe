
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] game_state;

    
    initial begin
        game_state = data;
    end

    
    always @(posedge clk) begin
        if (load) begin
            game_state <= data;
        end else begin
            
            reg [15:0] row;
            reg [15:0] col;
            reg [15:0] neighbours;
            reg [15:0] new_game_state;

            for (row = 0;
 row < 16;
 row++) begin
                for (col = 0;
 col < 16;
 col++) begin
                    neighbours = 0;
                    
                    for (int i = -1;
 i <= 1;
 i++) begin
                        for (int j = -1;
 j <= 1;
 j++) begin
                            if (i == 0 && j == 0) continue;
                            int new_row = (row + i + 16) % 16;
                            int new_col = (col + j + 16) % 16;
                            neighbours = neighbours + game_state[new_row * 16 + new_col];
                        end
                    end
                    
                    if (neighbours == 0) begin
                        new_game_state[row * 16 + col] = 0;
                    end else if (neighbours == 1 || neighbours == 4) begin
                        new_game_state[row * 16 + col] = game_state[row * 16 + col];
                    end else if (neighbours == 3) begin
                        new_game_state[row * 16 + col] = 1;
                    end
                end
            end
            game_state <= new_game_state;
        end
    end

endmodule
