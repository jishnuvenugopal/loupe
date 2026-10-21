
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    
    reg [511:0] current_state;
    reg [511:0] next_state;

    
    reg [511:0] neighborhood [511:0][511:0][511:0];

    
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 512;
 i++) begin
            for (int j = 0;
 j < 512;
 j++) begin
                for (int k = 0;
 k < 512;
 k++) begin
                    neighborhood[i][j][k] = current_state[i - 1] ^ current_state[i] ^ current_state[i + 1];
                end
            end
        end

        for (int i = 0;
 i < 512;
 i++) begin
            for (int j = 0;
 j < 512;
 j++) begin
                next_state[i] = neighborhood[i][j][j];
            end
        end
    end

    
    always @(posedge clk) begin
        q <= next_state;
    end

endmodule
