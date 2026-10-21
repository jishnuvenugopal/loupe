
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] initial_state;

    
    reg [255:0] game_state;

    
    always @(posedge clk) begin
        if (load) begin
            initial_state <= data;
            game_state <= initial_state;
        end
    end

    
    always @(posedge clk) begin
        for (genvar i = 0;
 i < 256;
 i = i + 16) begin
            reg [15:0] row = game_state[i:i+16];
            reg [15:0] count = 0;

            
            for (genvar j = 0;
 j < 16;
 j = j + 1) begin
                if (row[j] == 1) begin
                    count = count + 1;
                end
            end

            
            if (count == 0) begin
                q[i:i+16] <= 0;
            end else if (count == 1) begin
                q[i:i+16] <= 0;
            end else if (count == 2) begin
                q[i:i+16] <= row;
            end else if (count == 3) begin
                q[i:i+16] <= 1;
            end else if (count >= 4) begin
                q[i:i+16] <= 0;
            end
        end
    end

endmodule
