
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    
    reg [511:0] state [511:0];
    reg [511:0] next_state [511:0];

    
    reg [511:0] current_state;
    reg [511:0] next_current_state;

    
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= next_current_state;
        end

        for (int i = 0;
 i < 512;
 i++) begin
            for (int j = 0;
 j < 512;
 j++) begin
                for (int k = 0;
 k < 512;
 k++) begin
                    if (i == 0 || i == 511 || j == 0 || j == 511 || k == 0 || k == 511) begin
                        next_state[i][j][k] = 0;
                    end else begin
                        if (state[i-1][j-1][k-1] == 1 && state[i-1][j-1][k] == 1 && state[i-1][j-1][k+1] == 1) begin
                            next_state[i][j][k] = 0;
                        end else if (state[i-1][j-1][k-1] == 1 && state[i-1][j-1][k] == 1 && state[i-1][j-1][k+1] == 0) begin
                            next_state[i][j][k] = 1;
                        end else if (state[i-1][j-1][k-1] == 1 && state[i-1][j-1][k] == 0 && state[i-1][j-1][k+1] == 1) begin
                            next_state[i][j][k] = 1;
                        end else if (state[i-1][j-1][k-1] == 1 && state[i-1][j-1][k] == 0 && state[i-1][j-1][k+1] == 0) begin
                            next_state[i][j][k] = 0;
                        end else if (state[i-1][j-1][k-1] == 0 && state[i-1][j-1][k] == 1 && state[i-1][j-1][k+1] == 1) begin
                            next_state[i][j][k] = 1;
                        end else if (state[i-1][j-1][k-1] == 0 && state[i-1][j-1][k] == 1 && state[i-1][j-1][k+1] == 0) begin
                            next_state[i][j][k] = 0;
                        end else if (state[i-1][j-1][k-1] == 0 && state[i-1][j-1][k] == 0 && state[i-1][j-1][k+1] == 1) begin
                            next_state[i][j][k] = 1;
                        end else if (state[i-1][j-1][k-1] == 0 && state[i-1][j-1][k] == 0 && state[i-1][j-1][k+1] == 0) begin
                            next_state[i][j][k] = 0;
                        end
                    end
                end
            end
        end

        next_current_state <= next_state;
    end

    
    assign q = current_state;

endmodule
