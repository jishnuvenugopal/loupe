
module TopModule (
    input clk,
    input load,
    output reg [255:0] q
);

    
    reg [255:0] game_state;

    
    always @(posedge clk) begin
        if (load) begin
            
            game_state <= {256{1'b0}};
        end else begin
            
            game_state <= update_game_state(game_state);
        end
    end

    
    always @(*) begin
        
        reg [255:0] updated_game_state;

        
        for (int i = 0;
 i < 256;
 i = i + 16) begin
            
            reg [15:0] row = game_state[i:i+16];

            
            int count = 0;
            for (int j = 0;
 j < 16;
 j = j + 1) begin
                int neighbor_index = (i + j) % 256;
                if (row[j] == 1) begin
                    count = count + 1;
                end
            }

            
            if (count == 0 || count == 1) begin
                updated_game_state[i:i+16] = 1'b0;
            end else if (count == 2 || count == 3) begin
                updated_game_state[i:i+16] = row;
            end else if (count == 4 || count == 5) begin
                updated_game_state[i:i+16] = 1'b0;
            end
        end

        
        q <= updated_game_state;
    end

endmodule
